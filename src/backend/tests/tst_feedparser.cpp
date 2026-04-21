#include "catch2/catch_test_macros.hpp"
#include "dcbackend/feedparser.hpp"

#include <QBuffer>

using Qt::StringLiterals::operator""_s;
using namespace dc;

namespace {
Expected<PodcastFeed, Error> parse(const char* xml)
{
    QByteArray data(xml);
    QBuffer buf(&data);
    buf.open(QIODevice::ReadOnly);
    return createFeedParser()->parse(buf);
}
}

TEST_CASE("feedparser - minimal valid feed")
{
    auto result = parse(R"(<?xml version="1.0"?><rss><channel><title>Hello</title></channel></rss>)");

    REQUIRE(result.result());
    CHECK(result.result()->title == u"Hello"_s);
    CHECK(result.result()->episodes.isEmpty());
}

TEST_CASE("feedparser - feed-level fields")
{
    auto result = parse(R"(<rss><channel>
        <title>My Podcast</title>
        <link>https://example.com</link>
        <author>Jane Doe</author>
        <subtitle>A great show</subtitle>
        <description>Long description here</description>
        <category text="Technology"/>
        <image href="https://example.com/art.jpg"/>
        <explicit>true</explicit>
    </channel></rss>)");

    REQUIRE(result.result());
    const auto& feed = *result.result();
    CHECK(feed.title == u"My Podcast"_s);
    CHECK(feed.link == u"https://example.com"_s);
    CHECK(feed.hosts == u"Jane Doe"_s);
    CHECK(feed.subtitle == u"A great show"_s);
    CHECK(feed.description == u"Long description here"_s);
    CHECK(feed.primaryGenre == u"Technology"_s);
    CHECK(feed.imageUrl == u"https://example.com/art.jpg"_s);
    CHECK(feed.isExplicit == true);
}

TEST_CASE("feedparser - single episode with all fields")
{
    auto result = parse(R"(<rss><channel>
        <title>Feed</title>
        <item>
            <title>Ep 1</title>
            <description>Episode description</description>
            <enclosure url="https://example.com/ep1.mp3"/>
            <guid>https://example.com/ep1</guid>
            <pubDate>Mon, 01 Jan 2024 12:00:00 +0000</pubDate>
            <duration>42:00</duration>
            <explicit>yes</explicit>
        </item>
    </channel></rss>)");

    REQUIRE(result.result());
    REQUIRE(result.result()->episodes.size() == 1);
    const auto& ep = result.result()->episodes[0];
    CHECK(ep.title == u"Ep 1"_s);
    CHECK(ep.description == u"Episode description"_s);
    CHECK(ep.audioUrl == u"https://example.com/ep1.mp3"_s);
    CHECK(ep.guid == u"https://example.com/ep1"_s);
    CHECK(ep.duration == u"42:00"_s);
    CHECK(ep.isExplicit == true);
    CHECK(ep.pubDate == QDateTime::fromString(u"Mon, 01 Jan 2024 12:00:00 +0000"_s, Qt::RFC2822Date));
}

TEST_CASE("feedparser - multiple episodes preserved in order")
{
    auto result = parse(R"(<rss><channel>
        <title>Feed</title>
        <item><title>Ep 1</title></item>
        <item><title>Ep 2</title></item>
        <item><title>Ep 3</title></item>
    </channel></rss>)");

    REQUIRE(result.result());
    REQUIRE(result.result()->episodes.size() == 3);
    CHECK(result.result()->episodes[0].title == u"Ep 1"_s);
    CHECK(result.result()->episodes[1].title == u"Ep 2"_s);
    CHECK(result.result()->episodes[2].title == u"Ep 3"_s);
}

TEST_CASE("feedparser - explicit flag parsing")
{
    auto checkExplicit = [](const char* value) -> bool {
        std::string xml = std::string("<rss><channel><explicit>") + value + "</explicit></channel></rss>";
        auto result = parse(xml.c_str());
        REQUIRE(result.result());
        return result.result()->isExplicit;
    };

    CHECK(checkExplicit("true") == true);
    CHECK(checkExplicit("True") == true);
    CHECK(checkExplicit("yes") == true);
    CHECK(checkExplicit("Yes") == true);
    CHECK(checkExplicit("false") == false);
    CHECK(checkExplicit("no") == false);
    CHECK(checkExplicit("clean") == false);
}

TEST_CASE("feedparser - episode explicit flag")
{
    auto checkEpisodeExplicit = [](const char* value) -> bool {
        std::string xml = std::string("<rss><channel><item><explicit>") + value + "</explicit></item></channel></rss>";
        auto result = parse(xml.c_str());
        REQUIRE(result.result());
        REQUIRE(result.result()->episodes.size() == 1);
        return result.result()->episodes[0].isExplicit;
    };

    CHECK(checkEpisodeExplicit("true") == true);
    CHECK(checkEpisodeExplicit("yes") == true);
    CHECK(checkEpisodeExplicit("false") == false);
    CHECK(checkEpisodeExplicit("no") == false);
}

TEST_CASE("feedparser - content before channel tag is ignored")
{
    auto result = parse(R"(<rss>
        <title>This is outside channel and should be ignored</title>
        <channel>
            <title>Real Title</title>
        </channel>
    </rss>)");

    REQUIRE(result.result());
    CHECK(result.result()->title == u"Real Title"_s);
}

TEST_CASE("feedparser - no channel tag returns error")
{
    auto result = parse(R"(<?xml version="1.0"?><rss><notchannel/></rss>)");
    REQUIRE(result.error());
}

TEST_CASE("feedparser - malformed XML returns error")
{
    auto result = parse(R"(<?xml version="1.0"?><rss><channel><title>Oops</title>)");
    REQUIRE(result.error());
}

TEST_CASE("feedparser - unclosed item tag returns error")
{
    // <item> opened but </channel> comes before </item>
    auto result = parse(R"(<rss><channel>
        <title>Feed</title>
        <item><title>Episode</title>
    </channel></rss>)");
    REQUIRE(result.error());
}
