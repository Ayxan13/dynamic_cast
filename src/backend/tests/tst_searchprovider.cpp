#include "catch2/catch_message.hpp"
#include "catch2/catch_session.hpp"
#include "catch2/catch_test_macros.hpp"
#include "dcbackend/searchprovider.hpp"
#include "impl/waitfor.h"

#include <memory>
#include <qcontainerfwd.h>
#include <qcoreapplication.h>
#include <qnetworkaccessmanager.h>
#include <qnetworkreply.h>
#include <qnetworkrequest.h>
#include <qtimer.h>
#include <utility>

using Qt::StringLiterals::operator""_s;
using namespace dc;

namespace Catch {
template <>
struct StringMaker<PodcastSearchResult> {
    static std::string convert(PodcastSearchResult const& v)
    {
        return QString(
            "PodcastSearchResult{"
            "  id: %1,"
            "  title: \"%2\","
            "  hosts: \"%3\","
            "  rss: \"%4\","
            "  episodes: %5,"
            "  explicit: %6,"
            "  updated: \"%7\""
            "}")
            .arg(QString::number(v.id), v.title, v.hosts, v.rss, QString::number(v.episodeCount), (v.isExplicit ? u"true"_s : u"false"_s), v.lastUpdated)
            .toStdString();
    }
};
}

struct MockNetworkReply final : QNetworkReply {
    explicit MockNetworkReply(QByteArray data)
        : m_data(std::move(data))
    {
        setup(200, QNetworkReply::NoError);
    }

    explicit MockNetworkReply(QNetworkReply::NetworkError error, int code)
    {
        setup(code, error);
    }

    qint64 bytesAvailable() const override { return m_data.size() - m_offset + QNetworkReply::bytesAvailable(); }

    qint64 readData(char* data, qint64 maxlen) override
    {
        if (m_offset >= m_data.size()) {
            return -1;
        }
        qint64 len = std::min(maxlen, static_cast<qint64>(m_data.size() - m_offset));
        memcpy(data, m_data.constData() + m_offset, len);
        m_offset += len;
        return len;
    }

    void abort() override { }
    bool isSequential() const override { return true; }

private:
    void setup(int code, QNetworkReply::NetworkError error)
    {
        setAttribute(QNetworkRequest::HttpStatusCodeAttribute, code);
        setError(error, u"Mock Error Notification"_s);
        setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
        setOpenMode(QIODevice::ReadOnly);

        QTimer::singleShot(0, this, [this]() {
            if (isOpen()) {
                emit finished();
            }
        });
    }

    const QByteArray m_data;
    qint64 m_offset = 0;
};

struct MockNetworkManager final : INetworkProvider {
    explicit MockNetworkManager(QByteArray data)
        : m_data(std::move(data))
    {
    }
    explicit MockNetworkManager(QNetworkReply::NetworkError err, int code)
        : m_error(err)
        , m_code(code)
        , m_isError(true)
    {
    }

    DeleteLaterUniquePtr<QNetworkReply> get(const QUrl& /*url*/) override
    {
        if (m_isError) {
            return DeleteLaterUniquePtr<QNetworkReply> { new MockNetworkReply { m_error, m_code } };
        }
        return DeleteLaterUniquePtr<QNetworkReply> { new MockNetworkReply { m_data } };
    }

private:
    QByteArray m_data;
    QNetworkReply::NetworkError m_error = QNetworkReply::NoError;
    int m_code = 200;
    bool m_isError = false;
};

TEST_CASE("itunes search - success and filtering")
{
    QByteArray networkResponse = R"({
        "resultCount": 3, 
        "results": [
            {"collectionId": 101, "collectionName": "Valid", "feedUrl": "https://test.com/1"},
            {"collectionId": 102, "collectionName": "Incomplete but Valid", "feedUrl": "https://test.com/2"},
            {"collectionId": 103, "collectionName": "Invalid - No Feed"}
        ]
    })";

    auto searchProvider = createSearchProvider(std::make_shared<MockNetworkManager>(networkResponse));
    auto res = QCoro::waitFor(searchProvider->search("term", 10));

    REQUIRE(res.result());
    // Only two should survive: 101 and 102. 103 is filtered due to missing feed.
    CHECK(res.result()->size() == 2);
}

TEST_CASE("itunes search - network error mapping")
{
    auto searchProvider = createSearchProvider(std::make_shared<MockNetworkManager>(QNetworkReply::HostNotFoundError, 404));
    auto res = QCoro::waitFor(searchProvider->search("term", 10));

    REQUIRE(res.error());
    // Verify the variant contains a NetworkError
    CHECK(std::holds_alternative<QNetworkReply::NetworkError>(*res.error()));
    CHECK(std::get<QNetworkReply::NetworkError>(*res.error()) == QNetworkReply::HostNotFoundError);
}

TEST_CASE("itunes search - json parse error mapping")
{
    QByteArray malformed = R"({ "results": [ { "id": 101 )"; // Unclosed JSON
    auto searchProvider = createSearchProvider(std::make_shared<MockNetworkManager>(malformed));
    auto res = QCoro::waitFor(searchProvider->search("term", 10));

    REQUIRE(res.error());
    // Verify the variant contains a QJsonParseError
    CHECK(std::holds_alternative<QJsonParseError>(*res.error()));
    CHECK(std::get<QJsonParseError>(*res.error()).error != QJsonParseError::NoError);
}

TEST_CASE("itunes search - empty results")
{
    QByteArray emptyJson = R"({"resultCount": 0, "results": []})";
    auto searchProvider = createSearchProvider(std::make_shared<MockNetworkManager>(emptyJson));
    auto res = QCoro::waitFor(searchProvider->search("nonexistent", 10));

    REQUIRE(res.result());
    CHECK(res.result()->isEmpty());
}

int main(int argc, char** argv)
{
    QCoreApplication app(argc, argv);
    return Catch::Session().run(argc, argv);
}