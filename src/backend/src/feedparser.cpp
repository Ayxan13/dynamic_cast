#include "dcbackend/feedparser.hpp"

#include <QStringLiteral>
#include <QXmlStreamReader>

using Qt::StringLiterals::operator""_s;

namespace {
bool parseIsExplicit(const QString& value)
{
    return value.startsWith('t', Qt::CaseInsensitive) || value.startsWith('y', Qt::CaseInsensitive);
}

struct FeedParser final : public dc::IFeedParser {
    dc::Expected<dc::PodcastFeed, dc::Error> parse(QIODevice& feedData) const override
    {
        QXmlStreamReader reader { &feedData };

        bool channelTagSeen = false;

        dc::PodcastFeed feed;
        std::optional<dc::PodcastEpisode> episode;

        while (!reader.atEnd()) {
            reader.readNext();
            if (reader.isStartElement() && reader.name() == u"channel"_s) {
                channelTagSeen = true;
                continue;
            }

            if (!channelTagSeen) {
                continue;
            }

            if (reader.isEndElement()) {
                if (reader.name() == u"channel"_s) {
                    break;
                }
                if (reader.name() == u"item"_s) {
                    if (!episode.has_value()) {
                        return DC_ERR("Malformed feed");
                    }
                    feed.episodes.append(std::move(*episode));
                    episode.reset();
                }
                continue;
            }

            if (reader.isStartElement()) {
                if (episode.has_value()) {
                    if (reader.name() == u"title"_s) {
                        episode->title = reader.readElementText();
                    } else if (reader.name() == u"description"_s) {
                        episode->description = reader.readElementText();
                    } else if (reader.name() == u"enclosure"_s) {
                        episode->audioUrl = reader.attributes().value(u"url"_s).toString();
                    } else if (reader.name() == u"guid"_s) {
                        episode->guid = reader.readElementText();
                    } else if (reader.name() == u"pubDate"_s) {
                        episode->pubDate = QDateTime::fromString(reader.readElementText(), Qt::RFC2822Date);
                    } else if (reader.name() == u"duration"_s) {
                        episode->duration = reader.readElementText();
                    } else if (reader.name() == u"explicit"_s) {
                        episode->isExplicit = parseIsExplicit(reader.readElementText());
                    }
                } else {
                    if (reader.name() == u"title"_s) {
                        feed.title = reader.readElementText();
                    } else if (reader.name() == u"link"_s) {
                        feed.link = reader.readElementText();
                    } else if (reader.name() == u"author"_s) {
                        feed.hosts = reader.readElementText();
                    } else if (reader.name() == u"subtitle"_s) {
                        feed.subtitle = reader.readElementText();
                    } else if (reader.name() == u"description"_s) {
                        feed.description = reader.readElementText();
                    } else if (reader.name() == u"category"_s) {
                        feed.primaryGenre = reader.attributes().value(u"text"_s).toString();
                    } else if (reader.name() == u"explicit"_s) {
                        feed.isExplicit = parseIsExplicit(reader.readElementText());
                    } else if (reader.name() == u"image"_s) {
                        feed.imageUrl = reader.attributes().value(u"href"_s).toString();
                    } else if (reader.name() == u"item"_s) {
                        episode.emplace();
                    }
                }

                continue;
            }
        }

        if (!channelTagSeen) {
            return DC_ERR("Malformed feed, no channel tag");
        }

        if (episode.has_value()) {
            return DC_ERR("Malformed feed");
        }

        if (reader.hasError()) {
            return DC_ERR_RT(reader.errorString());
        }
        return dc::Expected<dc::PodcastFeed, dc::Error>(std::move(feed));
    }
};
}

std::unique_ptr<dc::IFeedParser> dc::createFeedParser()
{
    return std::make_unique<FeedParser>();
}
