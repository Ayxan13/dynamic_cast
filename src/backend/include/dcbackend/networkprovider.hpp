#pragma once

#include <memory>
#include <dccommon/qtext.hpp>
#include <QtNetwork/QNetworkReply>

namespace dc {
struct INetworkProvider {
    virtual ~INetworkProvider() = default;
    virtual DeleteLaterUniquePtr<QNetworkReply> get(const QUrl&) = 0;
};

std::shared_ptr<INetworkProvider> createNetworkProvider();
}
