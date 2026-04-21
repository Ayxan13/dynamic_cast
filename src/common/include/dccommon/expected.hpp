#pragma once

#include <QString>
#include <variant>

namespace dc {
template <class Res, class Err>
class Expected : private std::variant<Res, Err> {
    using Variant = std::variant<Res, Err>;
    Variant& variant() { return *this; }
    const Variant& variant() const { return *this; }

public:
    explicit Expected(Res res)
        : Variant(std::move(res))
    {
    }

    explicit Expected(Err err)
        : Variant(std::move(err))
    {
    }

    Err* error() { return std::get_if<Err>(&this->variant()); }
    const Err* error() const { return std::get_if<Err>(&this->variant()); }

    Res* result() { return std::get_if<Res>(&this->variant()); }
    const Res* result() const { return std::get_if<Res>(&this->variant()); }
};

struct Error {
    QString message;
    int line;

    template <class T>
    explicit(false) operator Expected<T, Error>() &&
    {
        return Expected<T, Error>(std::move(*this));
    }

    template <class T>
    explicit(false) operator Expected<T, Error>() &
    {
        return Expected<T, Error>(*this);
    }
};

#define DC_ERR(msg) dc::Error{QStringLiteral(u"" msg), __LINE__}
#define DC_ERR_RT(msg) dc::Error{(msg), __LINE__}
}
