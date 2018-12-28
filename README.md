# Developing Make(file) Pytorch CPP/CUDA Extension

Pytorch is a great neural network library that has both flexibility and power.  Personally, I think it is the best library for prototyping (advanced) dynamic neural networks fast.

Recently, pytorch introduced the ATen tensor library for all backend as well as CPP backend. Before the CPP extension, they used the python C Foreign Function Import library which allowed C interface. As an avid CUDA developer, I created multiple projects to speed up custom layers using the CFFI interface.

However, wrapping functions with a non object oriented program sometimes led to a ridiculous overhead when objects are required. Now that it supports the latest technology from 2011, c++11, we can now use object oriented programming for pytorch extensions!

The [official Pytorch CPP extension guide](https://pytorch.org/tutorials/advanced/cpp_extension.html) provides an extensive and useful tutorial for how to create a C++ extension with ATen. It uses the python `setuptools` package to compile and creates a python module.


# Drawbacks of Setuptools for Development

However, the setuptools is not really flexible as it primarily focuses on the deployment stage rather than the developing stage. Thus, it lacks a lot of features that are essential for fast development. Let's delve into few scenarios that I encountered while I was porting my pytorch cffi extensions to cpp extensions.

## Compile only updated files

When you make a huge project, you don't want to compile the entire project everytime you make a small change. However, if you use the setuptools, it creates objects for ALL source files, everytime you make a change. This is becomes extremely cumbersome especially when your project gets larger.

However, using `Makefile` allows you to cache all object files as you have control over all files.

## Parallel Compilation

When your project gets larger, you might want to compile a lot of files in paralle. Using `-j#` flag, you can parallelize compilation.

For example, if you type `make -j8`, it would compile 8 files in parallel.

## Debugging

As the setuptools is used primarily for deployment, debugging is not really easy.
Instead, you could pass `-g` (or `-g -G` for nvcc) when you use the Makefile.


# Making a pytorch extension with a Makefile


from pytorch [CONTRIBUTING.md](https://github.com/pytorch/pytorch/blob/master/CONTRIBUTING.md)
> `CUDA_DEVICE_DEBUG=1` will enable CUDA device function debug symbols (-g -G). This will be particularly helpful in debugging device code. However, it will slow down the build process for about 50% (compared to only DEBUG=1), so use wisely.
> `cuda-gdb` and `cuda-memcheck` ar`e your best CUDA debugging friends. Unlike `gdb`, `cuda-gdb` can display actual values in a CUDA tensor (rather than all zeros).


## Finding the Arguments and the Include Paths

Like all shared libraries, you would need to compile first and and link dependencies properly to make one. When you compile your project using the setuptools, you can see the actual compilation command that it invokes and we can deduce what would be required to make a project from a Makefile. Extra arguments that it uses are

```
-DTORCH_API_INCLUDE_EXTENSION_H -DTORCH_EXTENSION_NAME=$(EXTENSION_NAME) -D_GLIBCXX_USE_CXX11_ABI=0
```

In addition, we need to find headers. The pytorch provides CPP extensions with setuptools and we could see how it finds the headers and libraries. In `torch.utils.cpp_extension` you can find the function `include_paths`, which provides all header paths. We only need to pass it to the Makefile. Within a Makefile, we can run a python command and get the paths like the following.


```
PYTHON_HEADER_DIR := $(shell python -c 'from distutils.sysconfig import get_python_inc; print(get_python_inc())')
```

Note that the command above prints out all paths line by line.


## Archive Library


