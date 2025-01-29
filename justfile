configure:
  cmake -DCMAKE_TOOLCHAIN_FILE="./tricore-gcc-toolchain.cmake" -B build .

build:
  cmake --build build

flash:
  xvfb-run wine ~/.wine/drive_c/tricore-gdb-das.exe --elf_file ${workspaceFolder}/build/Blinky_Led.hex
