#pragma once

#include <QDateTime>
#include <QList>
#include <QString>
#include <QUuid>
#include <dccommon/expected.hpp>

class QByteArray;

namespace dc {
struct PodcastEpisode {
    QString title;
    QString description;
    QString audioUrl;
    QString guid;

    QDateTime pubDate;
    QString duration;

    bool isExplicit = false;
};

struct PodcastFeed {
    QString title;
    QString link;
    QString hosts;
    QString subtitle;
    QString description;
    QString imageUrl;
    QString primaryGenre;
    QList<PodcastEpisode> episodes;

    bool isExplicit = false;
};

struct IFeedParser {
    virtual ~IFeedParser() = default;
    virtual Expected<PodcastFeed, Error> parse(QIODevice& feedData) const = 0;
};

std::unique_ptr<IFeedParser> createFeedParser();
}
