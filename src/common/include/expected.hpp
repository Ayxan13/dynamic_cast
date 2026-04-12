#pragma once

#include <variant>

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
