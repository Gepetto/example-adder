#include "example-adder/gepadd.hpp"

namespace gepetto {
namespace example {
auto add(const long a, const long b) -> long { return a + b; }

auto sub(const long a, const long b) -> long { return a - b; }
} // namespace example
} // namespace gepetto
