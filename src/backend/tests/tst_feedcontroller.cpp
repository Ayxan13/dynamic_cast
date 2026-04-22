#include "catch2/catch_session.hpp"
#include "catch2/catch_test_macros.hpp"
#include "dcbackend/feedcontroller.hpp"
#include "dcbackend/feedprovider.hpp"

#include <QCoro/QCoroQmlTask>
#include <QCoro/QCoroTask>
#include <QEventLoop>
#include <QTimer>
#include <qcoreapplication.h>

using Qt::StringLiterals::operator""_s;
using namespace dc;

// ── Helpers ───────────────────────────────────────────────────────────────────

struct MockFeedProvider final : IFeedProvider {
    using Result = Expected<PodcastFeed, Error>;

    explicit MockFeedProvider(Result result)
        : m_result(std::move(result))
    {
    }

    QCoro::Task<Result> fetch(const QUrl& /*url*/) const override
    {
        co_return m_result;
    }

    Result m_result;
};

static void pumpEvents(int timeoutMs = 500)
{
    QEventLoop loop;
    QTimer::singleShot(timeoutMs, &loop, &QEventLoop::quit);
    loop.exec();
}

static FeedResult awaitFeedResult(QCoro::QmlTask task)
{
    auto* listener = task.await();
    if (!listener->value().isValid())
        pumpEvents();
    return listener->value().value<FeedResult>();
}

// ── Tests ─────────────────────────────────────────────────────────────────────

TEST_CASE("FeedController - successful fetch maps feed fields")
{
    PodcastFeed feed;
    feed.title        = u"My Podcast"_s;
    feed.hosts        = u"Alice"_s;
    feed.description  = u"A great show"_s;
    feed.imageUrl     = u"https://img.example.com/art.jpg"_s;
    feed.link         = u"https://example.com"_s;
    feed.primaryGenre = u"Technology"_s;

    FeedController controller(std::make_unique<MockFeedProvider>(
        Expected<PodcastFeed, Error> { feed }));

    const auto result = awaitFeedResult(controller.fetch(u"https://example.com/feed.xml"_s));

    CHECK(result.title        == u"My Podcast"_s);
    CHECK(result.hosts        == u"Alice"_s);
    CHECK(result.description  == u"A great show"_s);
    CHECK(result.imageUrl     == u"https://img.example.com/art.jpg"_s);
    CHECK(result.link         == u"https://example.com"_s);
    CHECK(result.primaryGenre == u"Technology"_s);
}

TEST_CASE("FeedController - episodes are mapped into QVariantList")
{
    PodcastFeed feed;
    PodcastEpisode ep;
    ep.title         = u"Episode 1"_s;
    ep.duration      = u"01:23:45"_s;
    ep.audioUrl      = u"https://example.com/ep1.mp3"_s;
    ep.episodeNumber = 7;
    ep.pubDate       = QDateTime(); // invalid — checked in next test
    feed.episodes    = { ep };

    FeedController controller(std::make_unique<MockFeedProvider>(
        Expected<PodcastFeed, Error> { feed }));

    const auto result = awaitFeedResult(controller.fetch(u"https://example.com/feed.xml"_s));

    REQUIRE(result.episodes.size() == 1);
    const auto epResult = result.episodes[0].value<EpisodeResult>();
    CHECK(epResult.title         == u"Episode 1"_s);
    CHECK(epResult.duration      == u"01:23:45"_s);
    CHECK(epResult.audioUrl      == u"https://example.com/ep1.mp3"_s);
    CHECK(epResult.episodeNumber == 7);
}

TEST_CASE("FeedController - valid pubDate is formatted correctly")
{
    PodcastFeed feed;
    PodcastEpisode ep;
    ep.pubDate = QDateTime(QDate(2024, 3, 15), QTime(9, 30, 0), QTimeZone::UTC);
    feed.episodes = { ep };

    FeedController controller(std::make_unique<MockFeedProvider>(
        Expected<PodcastFeed, Error> { feed }));

    const auto result = awaitFeedResult(controller.fetch(u"https://example.com/feed.xml"_s));

    REQUIRE(result.episodes.size() == 1);
    const auto epResult = result.episodes[0].value<EpisodeResult>();
    CHECK(epResult.pubDate == u"15 March 2024, 09:30"_s);
}

TEST_CASE("FeedController - invalid pubDate yields empty string")
{
    PodcastFeed feed;
    PodcastEpisode ep;
    ep.pubDate    = QDateTime(); // invalid
    feed.episodes = { ep };

    FeedController controller(std::make_unique<MockFeedProvider>(
        Expected<PodcastFeed, Error> { feed }));

    const auto result = awaitFeedResult(controller.fetch(u"https://example.com/feed.xml"_s));

    REQUIRE(result.episodes.size() == 1);
    CHECK(result.episodes[0].value<EpisodeResult>().pubDate.isEmpty());
}

TEST_CASE("FeedController - provider error emits fetchFailed")
{
    FeedController controller(std::make_unique<MockFeedProvider>(
        DC_ERR("network timeout")));

    QString captured;
    bool fired = false;
    QObject::connect(&controller, &FeedController::fetchFailed,
        [&](const QString& msg) { captured = msg; fired = true; });

    controller.fetch(u"https://example.com/feed.xml"_s);
    if (!fired)
        pumpEvents();

    CHECK(fired);
    CHECK(captured.contains(u"network timeout"_s));
}

TEST_CASE("FeedController - provider error returns empty FeedResult")
{
    FeedController controller(std::make_unique<MockFeedProvider>(
        DC_ERR("bad feed")));

    const auto result = awaitFeedResult(controller.fetch(u"https://example.com/feed.xml"_s));

    CHECK(result.title.isEmpty());
    CHECK(result.episodes.isEmpty());
}

TEST_CASE("FeedController - loading is true during fetch and false after")
{
    FeedController controller(std::make_unique<MockFeedProvider>(
        Expected<PodcastFeed, Error> { PodcastFeed {} }));

    QList<bool> history;
    QObject::connect(&controller, &FeedController::loadingChanged,
        [&] { history.append(controller.loading()); });

    CHECK(!controller.loading());
    awaitFeedResult(controller.fetch(u"https://example.com/feed.xml"_s));
    CHECK(!controller.loading());

    REQUIRE(history.size() >= 2);
    CHECK(history.first() == true);
    CHECK(history.last()  == false);
}

TEST_CASE("FeedController - empty episode list maps to empty QVariantList")
{
    FeedController controller(std::make_unique<MockFeedProvider>(
        Expected<PodcastFeed, Error> { PodcastFeed {} }));

    const auto result = awaitFeedResult(controller.fetch(u"https://example.com/feed.xml"_s));

    CHECK(result.episodes.isEmpty());
}

int main(int argc, char** argv)
{
    QCoreApplication app(argc, argv);
    return Catch::Session().run(argc, argv);
}
