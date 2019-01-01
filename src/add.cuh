template <typename Dtype>
void AddGPUKernel(Dtype *in_a, Dtype *in_b, Dtype *out_c, int N,
                  cudaStream_t stream);
