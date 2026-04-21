#include "catch2/catch_session.hpp"
#include "catch2/catch_test_macros.hpp"
#include "dcbackend/searchcontroller.hpp"
#include "dcbackend/searchprovider.hpp"

#include <QCoro/QCoroQmlTask>
#include <QCoro/QCoroTask>
#include <QEventLoop>
#include <QTimer>
#include <qcoreapplication.h>

using Qt::StringLiterals::operator""_s;
using namespace dc;

// ── Helpers ───────────────────────────────────────────────────────────────────

struct MockSearchProvider final : ISearchProvider {
    using Result = Expected<QVector<PodcastSearchResult>, Error>;

    explicit MockSearchProvider(Result result)
        : m_result(std::move(result))
    {
    }

    QCoro::Task<Result> search(const QString& /*term*/, int /*limit*/) const override
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

static PodcastSearchResult makePodcast(qint64 id, const QString& title, const QString& hosts)
{
    return PodcastSearchResult {
        .title         = title,
        .hosts         = hosts,
        .rss           = u"https://example.com/%1"_s.arg(id),
        .artworkUrl100 = u"https://img.example.com/%1.jpg"_s.arg(id),
        .id            = id,
    };
}

static QList<PodcastResult> awaitResults(QCoro::QmlTask task)
{
    auto* listener = task.await();
    if (!listener->value().isValid()) {
        pumpEvents();
    }
    return listener->value().value<QList<PodcastResult>>();
}

// ── Tests ─────────────────────────────────────────────────────────────────────

TEST_CASE("SearchController - successful search returns correct data")
{
    auto provider = std::make_unique<MockSearchProvider>(
        MockSearchProvider::Result { QVector<PodcastSearchResult> {
            makePodcast(1, u"Crime Junkie"_s,     u"audiochuck"_s),
            makePodcast(2, u"Hardcore History"_s, u"Dan Carlin"_s),
        } });

    SearchController controller(std::move(provider));

    const auto captured = awaitResults(controller.search(u"history"_s));

    REQUIRE(captured.size() == 2);
    CHECK(captured[0].podcastName == u"Crime Junkie"_s);
    CHECK(captured[0].author      == u"audiochuck"_s);
    CHECK(!captured[0].artworkUrl.isEmpty());

    CHECK(captured[1].podcastName == u"Hardcore History"_s);
    CHECK(captured[1].author      == u"Dan Carlin"_s);
}

TEST_CASE("SearchController - empty results returns empty list")
{
    auto provider = std::make_unique<MockSearchProvider>(
        MockSearchProvider::Result { QVector<PodcastSearchResult> {} });

    SearchController controller(std::move(provider));

    const auto captured = awaitResults(controller.search(u"xyzzy"_s));
    CHECK(captured.isEmpty());
}

TEST_CASE("SearchController - network error emits searchFailed with message")
{
    auto provider = std::make_unique<MockSearchProvider>(
        MockSearchProvider::Result { ISearchProvider::Error { QNetworkReply::HostNotFoundError } });

    SearchController controller(std::move(provider));

    QString captured;
    bool fired = false;
    QObject::connect(&controller, &SearchController::searchFailed,
        [&](const QString& msg) { captured = msg; fired = true; });

    controller.search(u"anything"_s);
    if (!fired) pumpEvents();

    CHECK(fired);
    CHECK(captured.contains(u"Network error"_s));
}

TEST_CASE("SearchController - json parse error emits searchFailed with message")
{
    QJsonParseError parseErr;
    parseErr.error = QJsonParseError::MissingObject;
    auto provider = std::make_unique<MockSearchProvider>(
        MockSearchProvider::Result { ISearchProvider::Error { parseErr } });

    SearchController controller(std::move(provider));

    QString captured;
    bool fired = false;
    QObject::connect(&controller, &SearchController::searchFailed,
        [&](const QString& msg) { captured = msg; fired = true; });

    controller.search(u"anything"_s);
    if (!fired) pumpEvents();

    CHECK(fired);
    CHECK(captured.contains(u"Parse error"_s));
}

TEST_CASE("SearchController - loading is true during search and false after")
{
    auto provider = std::make_unique<MockSearchProvider>(
        MockSearchProvider::Result { QVector<PodcastSearchResult> {} });

    SearchController controller(std::move(provider));

    QList<bool> loadingHistory;
    QObject::connect(&controller, &SearchController::loadingChanged,
        [&] { loadingHistory.append(controller.loading()); });

    CHECK(!controller.loading());
    awaitResults(controller.search(u"test"_s));

    CHECK(!controller.loading());
    REQUIRE(loadingHistory.size() >= 2);
    CHECK(loadingHistory.first() == true);
    CHECK(loadingHistory.last()  == false);
}

int main(int argc, char** argv)
{
    QCoreApplication app(argc, argv);
    return Catch::Session().run(argc, argv);
}
