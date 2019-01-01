#ifndef COMMON
#define COMMON

#include <iostream>
#include <string>

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
