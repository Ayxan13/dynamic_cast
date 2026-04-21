#include "dcbackend/networkprovider.hpp"

#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>

namespace {
struct QNAM_NetworkProvider final : dc::INetworkProvider {
    dc::DeleteLaterUniquePtr<QNetworkReply> get(const QUrl& url) override
    {
        return dc::DeleteLaterUniquePtr<QNetworkReply> { m_nam.get(QNetworkRequest { url }) };
    }

    QNetworkAccessManager m_nam;
};
} // namespace

std::shared_ptr<dc::INetworkProvider> dc::createNetworkProvider()
{
    return std::make_shared<QNAM_NetworkProvider>();
}
