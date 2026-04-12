#include "expected.hpp"

#include "catch2/catch_test_macros.hpp"
#include <string>

TEST_CASE("Initialization")
{
    SECTION("Success")
    {
        Expected<int, std::string> expected { 1 };
        REQUIRE(expected.result());
        REQUIRE_FALSE(expected.error());
        REQUIRE(*expected.result() == 1);
    }

    SECTION("Error")
    {
        Expected<int, std::string> expected { "Hello World" };
        REQUIRE_FALSE(expected.result());
        REQUIRE(expected.error());
        REQUIRE(*expected.error() == "Hello World");
    }
}

TEST_CASE("Assign")
{
    Expected<int, std::string> expected { 1 };
    REQUIRE(expected.result());
    REQUIRE_FALSE(expected.error());
    REQUIRE(*expected.result() == 1);

    expected = Expected<int, std::string> { "Hello World" };

    REQUIRE_FALSE(expected.result());
    REQUIRE(expected.error());
    REQUIRE(*expected.error() == "Hello World");
}
