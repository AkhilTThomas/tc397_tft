set(TARGET Blinky_LED)

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
    "${PROJECT_SOURCE_DIR}/Libraries/iLLD/TC39B/Tricore/Port/Std"
    "${PROJECT_SOURCE_DIR}/Libraries/iLLD/TC39B/Tricore/"
    "${PROJECT_SOURCE_DIR}/Libraries/Infra/Platform/"
    "${PROJECT_SOURCE_DIR}/Configurations/"
    "${PROJECT_SOURCE_DIR}/Libraries/Infra/Sfr/TC39B/_Reg/"
    "${PROJECT_SOURCE_DIR}/Libraries/Service/CpuGeneric/"
    "${PROJECT_SOURCE_DIR}/Libraries/Service/CpuGeneric/SysSe/Bsp/"
    "${PROJECT_SOURCE_DIR}/Libraries/iLLD/TC39B/Tricore/Cpu/Std/"
    "${PROJECT_SOURCE_DIR}/Libraries/iLLD/TC39B/Tricore/Scu/Std/"
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

