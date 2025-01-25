configure:
  cmake -DCMAKE_TOOLCHAIN_FILE="./tricore-gcc-toolchain.cmake" -B build .

build:
  cmake --build build
