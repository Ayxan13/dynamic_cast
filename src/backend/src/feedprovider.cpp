#include "dcbackend/feedprovider.hpp"
#include "dccommon/expected.hpp"

#include <QtNetwork/QNetworkReply>
#include <QtCore/QUrl>

#include <QCoro/QCoroNetworkReply>
#include <QCoro/QCoroTask>



using namespace dc;

namespace {
struct FeedProvider : dc::IFeedProvider {
    FeedProvider(std::unique_ptr<IFeedParser> feedParser, std::shared_ptr<INetworkProvider> networkProvider)
        : m_feedParser(std::move(feedParser))
        , m_networkProvider(std::move(networkProvider))
    {
        Q_ASSERT(m_feedParser);
        Q_ASSERT(m_networkProvider);
    }

    FeedProvider(const FeedProvider&) = delete;
    FeedProvider(FeedProvider&&) = delete;
    FeedProvider& operator=(const FeedProvider&) = delete;
    FeedProvider& operator=(FeedProvider&&) = delete;
    ~FeedProvider() = default;


    QCoro::Task<Expected<PodcastFeed, Error>> fetch(const QUrl& url) const override
    {
        Q_ASSERT(m_feedParser);
        Q_ASSERT(m_networkProvider);

        DeleteLaterUniquePtr<QNetworkReply> reply = m_networkProvider->get(url);
        if (!reply) {
            co_return DC_ERR("Network Error");
        }

        co_await reply.get();
        co_return this->m_feedParser->parse(*reply);
    }

private:
    std::unique_ptr<IFeedParser> m_feedParser;
    std::shared_ptr<INetworkProvider> m_networkProvider;
};
}

std::unique_ptr<dc::IFeedProvider> dc::createFeedProvider(std::unique_ptr<IFeedParser> feedParser, std::shared_ptr<INetworkProvider> networkProvider)
{
    return std::make_unique<FeedProvider>(std::move(feedParser), std::move(networkProvider));
}