#include "src/gpu.cuh"
#include "src/utils.hpp"

template <typename Dtype>
__global__ void sum(Dtype *a, Dtype *b, Dtype *c, int N) {
  int i = blockIdx.x * blockDim.x + threadIdx.x;
  if (i <= N) {
    c[i] = a[i] + b[i];
  }
}

template <typename Dtype>
void AddGPUKernel(Dtype *in_a, Dtype *in_b, Dtype *out_c, int N,
                  cudaStream_t stream) {
  sum<Dtype>
      <<<GET_BLOCKS(N), CUDA_NUM_THREADS, 0, stream>>>(in_a, in_b, out_c, N);

  cudaError_t err = cudaGetLastError();
  if (cudaSuccess != err)
    throw std::runtime_error(Formatter()
                             << "CUDA kernel failed : " << std::to_string(err));
}

template void AddGPUKernel<float>(float *in_a, float *in_b, float *out_c, int N,
                                  cudaStream_t stream);
