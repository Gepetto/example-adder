#include <cassert>

#include "example-adder/gepadd.hpp"

auto main() -> int {
  assert(gepetto::example::add(1, 2) == 3);
  assert(gepetto::example::add(5, -1) == 4);
  assert(gepetto::example::add(-3, -1) == -4);
  return 0;
}
