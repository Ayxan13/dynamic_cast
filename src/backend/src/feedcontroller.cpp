#include "dcbackend/feedcontroller.hpp"

#include <QUrl>
#include <qscopeguard.h>

dc::FeedController::FeedController(std::unique_ptr<IFeedProvider> provider, QObject* parent)
    : QObject(parent)
    , m_provider(std::move(provider))
{
}

QCoro::QmlTask dc::FeedController::fetch(const QString& url)
{
    return doFetch(url);
}

void dc::FeedController::setLoading(const bool newValue)
{
    if (m_loading != newValue) {
        m_loading = newValue;
        emit loadingChanged();
    }
}

QCoro::Task<dc::FeedResult> dc::FeedController::doFetch(QString url)
{
    setLoading(true);
    const QScopeGuard resetLoading { [this] { setLoading(false); } };

    auto result = co_await m_provider->fetch(QUrl(url));

    if (auto* err = result.error()) {
        emit fetchFailed(err->message);
        co_return {};
    }

    const auto& feed = *result.result();

    QVariantList eps;
    eps.reserve(feed.episodes.size());
    for (const auto& ep : feed.episodes) {
        eps.append(QVariant::fromValue(EpisodeResult {
            .title         = ep.title,
            .pubDate       = ep.pubDate.isValid()
                                 ? ep.pubDate.toString(QStringLiteral("dd MMMM yyyy, HH:mm"))
                                 : QString{},
            .duration      = ep.duration,
            .audioUrl      = ep.audioUrl,
            .episodeNumber = ep.episodeNumber,
        }));
    }

    co_return FeedResult {
        .title        = feed.title,
        .hosts        = feed.hosts,
        .description  = feed.description,
        .imageUrl     = feed.imageUrl,
        .link         = feed.link,
        .primaryGenre = feed.primaryGenre,
        .episodes     = eps,
    };
}
