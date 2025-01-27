cmake_minimum_required(VERSION 3.16)

project(Blinky_Led C)
set(TARGET ${PROJECT_NAME})

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

add_executable(${TARGET}
  Blinky_LED.c
  Cpu0_Main.c
  Cpu1_Main.c
  Cpu2_Main.c
  Cpu3_Main.c
  Cpu4_Main.c
  Cpu5_Main.c
)

target_compile_features(${TARGET} PRIVATE c_std_99 cxx_std_11)

target_link_options(${TARGET} PRIVATE -Wl,-Map=${CMAKE_CURRENT_BINARY_DIR}/${TARGET}.map)

target_include_directories(${TARGET}
  PUBLIC
    "./Libraries/iLLD/TC39B/Tricore/Port/Std"
    "./Libraries/iLLD/TC39B/Tricore/"
    "./Libraries/Infra/Platform/"
    "./Configurations/"
    "./Libraries/Infra/Sfr/TC39B/_Reg/"
    "./Libraries/Service/CpuGeneric/"
    "./Libraries/Service/CpuGeneric/SysSe/Bsp/"
    "./Libraries/iLLD/TC39B/Tricore/Cpu/Std/"
    "./Libraries/iLLD/TC39B/Tricore/Scu/Std/"
)

target_link_libraries(${TARGET} configurations port)
# force executable output name to be formatted as "EXEC_NAME.elf"
set_target_properties(${TARGET} PROPERTIES OUTPUT_NAME ${TARGET} SUFFIX .elf)

#Add custom command to generate the .hex file, and
# create a custom target to build it
find_program(OBJDUMP_BIN NAMES tricore-objcopy tricore-elf-objcopy REQUIRED)
add_custom_command(
  OUTPUT ${TARGET}.hex
  COMMAND ${OBJDUMP_BIN} ${TARGET}.elf -O ihex ${TARGET}.hex
  DEPENDS ${TARGET}
  COMMENT "Generate ${TARGET}.hex"
  VERBATIM
)
add_custom_target(HexFile ALL DEPENDS ${TARGET}.hex)
