default:
  @just --list

# Run CMake configure
configure:
  cmake -DCMAKE_TOOLCHAIN_FILE="./tricore-gcc-toolchain.cmake" -B build .

# Build the project
build:
  cmake --build build

# Flash the hex file
_flash hex_file:
  xvfb-run -a wine ~/.wine/drive_c/tricore-gdb-das.exe --elf_file {{hex_file}}

# Flash the blinky program
flash-blinky:
  @just _flash $(pwd)/build/blinky/Blinky_LED.hex

# Flash the multicore program
flash-multicore:
  @just _flash $(pwd)/build/multicore/multicore.hex
