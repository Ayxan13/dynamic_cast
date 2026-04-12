#pragma once

#include <QtCore/QObject>
#include <QtCore/QString>
#include <memory>

namespace dc {
struct PodcastSearchResult {
    QString artistName;
    QString collectionName;
    QString feedUrl;
    QString artworkUrl30;
    QString artworkUrl60;
    QString artworkUrl100;
    QString artworkUrl600;
    QString country;
    QString primaryGenreName;
    QString genres;
};

struct ISearchProvider {
    virtual ~ISearchProvider() = default;

    virtual bool search(
        const QString& term, // Search term, i.e., user input
        int limit,     // Max number of results we want. In the range of 1 to 200
        QVector<PodcastSearchResult>& result // Search results.
    ) const = 0;
};

std::unique_ptr<ISearchProvider> createSearchProvider();
}