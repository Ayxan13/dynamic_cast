#include "dcbackend/searchcontroller.hpp"

#include <qscopeguard.h>

using Qt::StringLiterals::operator""_s;

dc::SearchController::SearchController(std::unique_ptr<ISearchProvider> provider, QObject* parent)
    : QObject(parent)
    , m_provider(std::move(provider))
{
}

QCoro::QmlTask dc::SearchController::search(const QString& term)
{
    return doSearch(term);
}

void dc::SearchController::setLoading(const bool newValue)
{
    if (m_loading != newValue) {
        m_loading = newValue;
        emit loadingChanged();
    }
}

QCoro::Task<QList<dc::PodcastResult>> dc::SearchController::doSearch(QString term)
{
    setLoading(true);
    const QScopeGuard resetLoading { [this] { setLoading(false); } };

    auto result = co_await m_provider->search(term, 50);

    if (auto* err = result.error()) {
        const QString msg = std::visit(
            [](auto& e) -> QString {
                if constexpr (std::is_same_v<std::decay_t<decltype(e)>, QNetworkReply::NetworkError>) {
                    return u"Network error: %1"_s.arg(static_cast<int>(e));
                } else {
                    return u"Parse error: %1"_s.arg(e.errorString());
                }
            },
            *err);
        emit searchFailed(msg);
        co_return {};
    }

    QList<PodcastResult> list;
    list.reserve(result.result()->size());
    for (const auto& pod : *result.result()) {
        list.append(PodcastResult {
            .podcastName = pod.title,
            .author = pod.hosts,
            .artworkUrl = pod.artworkUrl100,
            .rssUrl = pod.rss,
        });
    }
    co_return list;
}
