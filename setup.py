import os
from setuptools import setup
from torch.utils.cpp_extension import CUDAExtension, BuildExtension

os.system('make -j%d' % os.cpu_count())

# Python interface
setup(
    name='PytorchMakefileTutorial',
    version='0.2.0',
    install_requires=['torch'],
    packages=['MakePytorchPlusPlus'],
    package_dir={'MakePytorchPlusPlus': './'},
    ext_modules=[
        CUDAExtension(
            name='MakePytorchBackend',
            include_dirs=['./'],
            sources=[
                'pybind/bind.cpp',
            ],
            libraries=['make_pytorch'],
            library_dirs=['objs'],
            # extra_compile_args=['-g']
        )
    ],
    cmdclass={'build_ext': BuildExtension},
    author='Christopher B. Choy',
    author_email='chrischoy@ai.stanford.edu',
    description='Tutorial for Pytorch C++ Extension with a Makefile',
    keywords='Pytorch C++ Extension',
    url='https://github.com/chrischoy/MakePytorchPlusPlus',
    zip_safe=False,
)
