#pragma once

#include "dcbackend/feedparser.hpp"
#include "dcbackend/networkprovider.hpp"
#include <QCoro/QCoroTask>
#include <memory>

class QUrl;

namespace dc {
struct IFeedProvider {
    virtual ~IFeedProvider() = default;
    virtual QCoro::Task<Expected<PodcastFeed, Error>> fetch(const QUrl& url) const = 0;
};

std::unique_ptr<IFeedProvider> createFeedProvider(std::unique_ptr<IFeedParser>, std::shared_ptr<INetworkProvider>);
}
