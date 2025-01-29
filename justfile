default:
  @just --list

# Run CMake configure
configure:
  cmake -DCMAKE_TOOLCHAIN_FILE="./tricore-gcc-toolchain.cmake" -B build .

# Build the project
build:
  cmake --build build

# Flash the hex
flash:
  xvfb-run wine ~/.wine/drive_c/tricore-gdb-das.exe --elf_file $(pwd)/build/Blinky_Led.hex
