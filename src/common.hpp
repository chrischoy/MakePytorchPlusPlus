#ifndef COMMON
#define COMMON

#include <iostream>
#include <string>

constexpr int CUDA_NUM_THREADS = 128;

constexpr int MAXIMUM_NUM_BLOCKS = 4096;

inline int GET_BLOCKS(const int N) {
  return std::max(std::min((N + CUDA_NUM_THREADS - 1) / CUDA_NUM_THREADS,
                           MAXIMUM_NUM_BLOCKS),
                  // Use at least 1 block, since CUDA does not allow empty block
                  1);
}

class Foo {
private:
  uint64_t key_;

public:
  void setKey(uint64_t key);
  uint64_t getKey();
  std::string toString() const {
    return "< Foo, key: " + std::to_string(key_) + " > ";
  };
};

#endif
