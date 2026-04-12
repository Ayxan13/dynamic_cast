#pragma once

#include <concepts>
#include <memory>

class QObject;

namespace dc {
struct DeleteLater {
    void operator()(QObject* p);
};

template <std::derived_from<QObject> T>
using DeleteLaterUniquePtr = std::unique_ptr<T, DeleteLater>;
}