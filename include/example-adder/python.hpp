#ifndef __example_adder_python__
#define __example_adder_python__

#include "example-adder/gepadd.hpp"

#include <boost/python.hpp>

namespace gepetto {
namespace example {
void exposeExampleAdder();
void exposeActionUniEx();
}  // namespace example
}  // namespace gepetto

#endif
