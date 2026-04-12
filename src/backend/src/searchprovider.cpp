#include "dcbackend/searchprovider.hpp"

#include <QtCore/QJsonArray>
#include <QtCore/QJsonDocument>
#include <QtCore/QJsonValue>
#include <QtCore/QStringLiteral>
#include <QtCore/QUrlQuery>
#include <QtCore/QtAssert>
#include <QtNetwork/QNetworkReply>

#include <QCoro/QCoroNetworkReply>
#include <qcontainerfwd.h>
#include <qobject.h>

using Qt::StringLiterals::operator""_s;
using namespace dc;

namespace {
struct ItunesSearchProvider final : dc::ISearchProvider {
    explicit ItunesSearchProvider(std::shared_ptr<INetworkProvider> network)
        : m_network(std::move(network))
    {
        Q_ASSERT(m_network != nullptr);
    }

    ItunesSearchProvider(const ItunesSearchProvider&) = delete;
    ItunesSearchProvider& operator=(const ItunesSearchProvider&) = delete;
    ~ItunesSearchProvider() = default;

    QCoro::Task<Expected<QVector<PodcastSearchResult>, Error>> search(
        const QString& term, int limit) const override;

private:
    std::shared_ptr<INetworkProvider> m_network;
};

QCoro::Task<Expected<QVector<PodcastSearchResult>, dc::ISearchProvider::Error>> ItunesSearchProvider::search(
    const QString& term, int limit) const
{
    Q_ASSERT(limit > 0);
    Q_ASSERT(limit < SearchLimitMax);

    QJsonDocument doc;
    {
        QByteArray networkData;
        {
            QUrl url { "https://itunes.apple.com/search" };
            url.setQuery(QUrlQuery {
                std::pair { u"term"_s, term },
                std::pair { u"media"_s, u"podcast"_s },
                std::pair { u"entity"_s, u"podcast"_s },
            });
            DeleteLaterUniquePtr<QNetworkReply> networkReply = m_network->get(url);
            Q_ASSERT(networkReply != nullptr);
            co_await networkReply.get();

            if (QNetworkReply::NetworkError err = networkReply->error(); err != QNetworkReply::NoError) {
                co_return err;
            }
            networkData = networkReply->readAll();
        }
        QJsonParseError err = { };
        doc = QJsonDocument::fromJson(networkData, &err);
        if (err.error != QJsonParseError::ParseError::NoError) {
            co_return err;
        }
    }

    const QJsonArray jsonResults = doc[u"results"_s].toArray();
    QVector<PodcastSearchResult> podcasts;
    podcasts.reserve(jsonResults.size());

    for (const auto& value : jsonResults) {
        PodcastSearchResult pod {
            .title = value[u"collectionName"_s].toString(),
            .hosts = value[u"artistName"_s].toString(),
            .rss = value[u"feedUrl"_s].toString(),
            .artworkUrl30 = value[u"artworkUrl30"_s].toString(),
            .artworkUrl60 = value[u"artworkUrl60"_s].toString(),
            .artworkUrl100 = value[u"artworkUrl100"_s].toString(),
            .artworkUrl600 = value[u"artworkUrl600"_s].toString(),
            .lastUpdated = value[u"releaseDate"_s].toString(),
            .genre = value[u"primaryGenreName"_s].toString(),
            .id = value[u"collectionId"_s].toVariant().toLongLong(),
            .episodeCount = value[u"trackCount"_s].toInt(0),
            .isExplicit = (value[u"contentAdvisoryRating"_s].toString() == u"Explicit"_s),
        };

        // If certain fields are missing, we can't use this
        if (pod.rss.isEmpty() || pod.id < 1 || pod.title.isEmpty()) {
            continue;
        }
        podcasts.push_back(std::move(pod));
    }

    co_return Expected<QVector<PodcastSearchResult>, Error> { std::move(podcasts) };
}
}

std::unique_ptr<dc::ISearchProvider> dc::createSearchProvider(std::shared_ptr<INetworkProvider> network)
{
    return std::make_unique<ItunesSearchProvider>(std::move(network));
}
