
add_library(port
  OBJECT
  "./iLLD/TC39B/Tricore/Port/Io/IfxPort_Io.c"
  "./iLLD/TC39B/Tricore/Port/Std/IfxPort.c"
)

target_include_directories(port
  PUBLIC
  "${PROJECT_SOURCE_DIR}/Libraries/iLLD/TC39B/Tricore/"
  "${PROJECT_SOURCE_DIR}/Libraries/iLLD/TC39B/Tricore/Port/Io/"
  "${PROJECT_SOURCE_DIR}/Libraries/iLLD/TC39B/Tricore/Port/Std/"
  "${PROJECT_SOURCE_DIR}/Libraries/Infra/Platform/"
  "${PROJECT_SOURCE_DIR}/Configurations/"
  "${PROJECT_SOURCE_DIR}/Libraries/Infra/Sfr/TC39B/_Reg/"
  "${PROJECT_SOURCE_DIR}/Libraries/Service/CpuGeneric/"
)


