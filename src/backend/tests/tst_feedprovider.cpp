#include "catch2/catch_session.hpp"
#include "catch2/catch_test_macros.hpp"
#include "dcbackend/feedprovider.hpp"

#include <QCoro/QCoroTask>
#include <QNetworkReply>
#include <QTimer>
#include <QUrl>
#include <qcoreapplication.h>

using Qt::StringLiterals::operator""_s;
using namespace dc;

// ── Mocks ──────────────────────────────────────────────────────────────────────

struct MockNetworkReply final : QNetworkReply {
    explicit MockNetworkReply()
    {
        setOpenMode(QIODevice::ReadOnly);
        QTimer::singleShot(0, this, [this]() { emit finished(); });
    }

    void abort() override { }
    bool isSequential() const override { return true; }

protected:
    qint64 readData(char* /*buf*/, qint64 /*maxlen*/) override { return -1; }
};

struct MockNetworkProvider final : INetworkProvider {
    bool returnNull;

    explicit MockNetworkProvider(bool returnNull = false)
        : returnNull(returnNull)
    {
    }

    DeleteLaterUniquePtr<QNetworkReply> get(const QUrl& /*url*/) override
    {
        if (returnNull) {
            return {};
        }
        return DeleteLaterUniquePtr<QNetworkReply> { new MockNetworkReply {} };
    }
};

struct MockFeedParser final : IFeedParser {
    using Result = Expected<PodcastFeed, Error>;

    explicit MockFeedParser(Result result)
        : m_result(std::move(result))
    {
    }

    Result parse(QIODevice& /*device*/) const override { return m_result; }

    Result m_result;
};

// ── Tests ──────────────────────────────────────────────────────────────────────

TEST_CASE("FeedProvider - successful fetch returns parsed feed")
{
    PodcastFeed feed;
    feed.title = u"My Podcast"_s;
    feed.description = u"A great show"_s;

    auto parser   = std::make_unique<MockFeedParser>(Expected<PodcastFeed, Error> { feed });
    auto network  = std::make_shared<MockNetworkProvider>();
    auto provider = createFeedProvider(std::move(parser), network);

    auto result = QCoro::waitFor(provider->fetch(QUrl(u"https://example.com/feed.xml"_s)));

    REQUIRE(result.result());
    CHECK(result.result()->title == u"My Podcast"_s);
    CHECK(result.result()->description == u"A great show"_s);
}

TEST_CASE("FeedProvider - null network reply returns error")
{
    auto parser   = std::make_unique<MockFeedParser>(Expected<PodcastFeed, Error> { PodcastFeed {} });
    auto network  = std::make_shared<MockNetworkProvider>(true);
    auto provider = createFeedProvider(std::move(parser), network);

    auto result = QCoro::waitFor(provider->fetch(QUrl(u"https://example.com/feed.xml"_s)));

    CHECK(result.error() != nullptr);
}

TEST_CASE("FeedProvider - parser error is propagated")
{
    auto parser   = std::make_unique<MockFeedParser>(Expected<PodcastFeed, Error> { DC_ERR("bad xml") });
    auto network  = std::make_shared<MockNetworkProvider>();
    auto provider = createFeedProvider(std::move(parser), network);

    auto result = QCoro::waitFor(provider->fetch(QUrl(u"https://example.com/feed.xml"_s)));

    REQUIRE(result.error() != nullptr);
    CHECK(result.error()->message.contains(u"bad xml"_s));
}

int main(int argc, char** argv)
{
    QCoreApplication app(argc, argv);
    return Catch::Session().run(argc, argv);
}
