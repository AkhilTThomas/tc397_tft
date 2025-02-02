set(TARGET multicore)

add_executable(${TARGET}
  Cpu0_Main.c
  Cpu1_Main.c
  Cpu2_Main.c
  Cpu3_Main.c
  Cpu4_Main.c
  Cpu5_Main.c
  Multicore.c
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

create_hex(${TARGET})
