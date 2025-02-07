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

find_program(OBJDUMP_BIN NAMES tricore-objcopy tricore-elf-objcopy REQUIRED)

# Add custom command to generate the .hex file
# create a custom target to build it
function(create_hex target)
  add_custom_target(${target}_hex
      ALL
      COMMAND ${OBJDUMP_BIN} ${target}.elf -O ihex ${target}.hex
      DEPENDS ${target}
      COMMENT "Generating ${target}.hex"
      VERBATIM
  )
endfunction()

add_subdirectory(Libraries)
add_subdirectory(Configurations)

# Start adding each examples
add_subdirectory(blinky)
add_subdirectory(multicore)
