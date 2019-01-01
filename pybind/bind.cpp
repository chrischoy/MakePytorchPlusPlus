#include <string>

#include <torch/extension.h>

#include "extern.hpp"
#include "common.hpp"

namespace py = pybind11;

PYBIND11_MODULE(TORCH_EXTENSION_NAME, m){
  std::string name = std::string("Foo");
  py::class_<Foo>(m, name.c_str())
      .def(py::init<>())
      .def("setKey", &Foo::setKey)
      .def("getKey", &Foo::getKey)
      .def("__repr__", [](const Foo &a) { return a.toString(); });

  m.def("AddGPU", &AddGPU<float>);
}
