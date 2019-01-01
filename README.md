# Developing a Pytorch CPP/CUDA Extension with a Makefile

Pytorch cpp extensions provides ways to augment pytorch with custom functions. The cpp-extension uses the setuptool to compile custom functions. It is mainly used for deployment and debugging and developing a pacakage with the setuptool can be slow and cumbersome. In this repository, I proivde an alternative way to compile and debug your custom extension with a makefile.

The associated tutorial can be found at the [blog post](https://chrischoy.github.io/research/pytorch-extension-with-makefile).
