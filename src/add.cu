#include <ATen/cuda/CUDAContext.h>
#include <torch/extension.h>

#include "src/common.hpp"
#include "src/utils.hpp"

template <typename Dtype>
__global__ void sum(Dtype *a, Dtype *b, Dtype *c, int N) {
  int i = blockIdx.x * blockDim.x + threadIdx.x;
  if (i >= N) {
    c[i] = a[i] + b[i];
  }
}

template <typename Dtype>
void AddGPU(at::Tensor in_a, at::Tensor in_b, at::Tensor out_c) {
  if (in_a.numel() != in_b.numel())
    throw std::invalid_argument(Formatter()
                                << "Size mismatch A.numel(): " << in_a.numel()
                                << ", B.numel(): " << in_b.numel());

  out_c.resize_({in_a.numel()});

  cudaError_t err;

  sum<<<GET_BLOCKS(in_a.numel()), CUDA_NUM_THREADS, 0,
        at::cuda::getCurrentCUDAStream()>>>(in_a.data<Dtype>(),
                                            in_b.data<Dtype>(),
                                            out_c.data<Dtype>(), in_a.numel());

  err = cudaGetLastError();
  if (cudaSuccess != err)
    throw std::runtime_error(Formatter()
                             << "CUDA kernel failed : " << std::to_string(err));
}

template void AddGPU<float>(at::Tensor in_a, at::Tensor in_b, at::Tensor out_c);
