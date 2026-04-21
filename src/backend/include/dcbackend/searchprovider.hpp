#pragma once

#include "qcorotask.h"
#include <QCoro/QCoroTask>
#include <memory>

#include <dccommon/expected.hpp>
#include <dcbackend/networkprovider.hpp>
#include <dccommon/qtext.hpp>
#include <qcontainerfwd.h>
#include <qjsonparseerror.h>
#include <qnetworkreply.h>
#include <qobject.h>
#include <qtypes.h>

namespace dc {
struct PodcastSearchResult {
    QString title; // collectionName
    QString hosts; // artistName
    QString rss; // feedUrl

    QString artworkUrl30;
    QString artworkUrl60;
    QString artworkUrl100;
    QString artworkUrl600;

    QString lastUpdated; // releaseDate
    QString genre; // primaryGenreName

    qint64 id; // collectionId
    int episodeCount; // trackCount
    bool isExplicit; // contentAdvisoryRating

    bool operator==(const PodcastSearchResult&) const = default;
};

struct ISearchProvider {
    static constexpr int SearchLimitMax = 200;

    virtual ~ISearchProvider() = default;

    using Error = std::variant<QNetworkReply::NetworkError, QJsonParseError>;

    virtual QCoro::Task<Expected<QVector<PodcastSearchResult>, Error>> search(
        const QString& term, // Search term, i.e., user input
        int limit // Max number of results we want. In the range of 1 to SearchLimitMax
    ) const = 0;
};

std::unique_ptr<ISearchProvider> createSearchProvider(std::shared_ptr<INetworkProvider>);
}
