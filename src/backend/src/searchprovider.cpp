#include "dc_backend/searchprovider.hpp"

#include <QtCore/QStringLiteral>

namespace {
struct SearchProvider final : dc::ISearchProvider {
    QString greeting() const override
    {
        return QStringLiteral("Hello World!");
    }
};
}

std::unique_ptr<dc::ISearchProvider> dc::createSearchProvider()
{
    return std::make_unique<SearchProvider>();
}
