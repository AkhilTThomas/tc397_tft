cmake_minimum_required(VERSION 3.16)

project(tc39x C)

set(CMAKE_C_FLAGS "\
  -mtc162 \
  -Wall   \
  -g      \
  -Wpointer-arith \
  -Wshadow -Wfloat-equal -Wno-unused-local-typedefs -Wextra -fno-common \
  -fstrict-volatile-bitfields -ffunction-sections -fdata-sections"
)
set(CMAKE_CXX_FLAGS "\
  -mtc162 -Wall -Wpointer-arith -Wshadow -Wfloat-equal \
  -Wno-unused-local-typedefs -Wextra -fno-common -fstrict-volatile-bitfields \
  -ffunction-sections -fdata-sections"
)

set(CMAKE_EXE_LINKER_FLAGS "\
  -nostartfiles -mtc162 -Wl,--gc-sections -Wl,--extmap=a -Wl,-n \
  -Wl,-T ${CMAKE_SOURCE_DIR}/Lcf_Gnuc_Tricore_Tc.lsl"
)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

add_subdirectory(Libraries)
add_subdirectory(Configurations)

# Start adding each examples
add_subdirectory(blinky)
add_subdirectory(multicore)
