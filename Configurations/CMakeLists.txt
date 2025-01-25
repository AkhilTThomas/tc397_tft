add_library(configurations
  OBJECT
  Ifx_Cfg_Ssw.c
  Ifx_Cfg_SswBmhd.c
  "../Libraries/Infra/Ssw/TC39B/Tricore/Ifx_Ssw_Tc0.c"
  "../Libraries/Infra/Ssw/TC39B/Tricore/Ifx_Ssw_Tc1.c"
  "../Libraries/Infra/Ssw/TC39B/Tricore/Ifx_Ssw_Tc2.c"
  "../Libraries/Infra/Ssw/TC39B/Tricore/Ifx_Ssw_Tc3.c"
  "../Libraries/Infra/Ssw/TC39B/Tricore/Ifx_Ssw_Tc4.c"
  "../Libraries/Infra/Ssw/TC39B/Tricore/Ifx_Ssw_Infra.c"
  "../Libraries/Infra/Ssw/TC39B/Tricore/Ifx_Ssw_Tc5.c"
  "../Libraries/iLLD/TC39B/Tricore/Scu/Std/IfxScuWdt.c"
  "../Libraries/iLLD/TC39B/Tricore/Scu/Std/IfxScuCcu.c"
  "../Libraries/iLLD/TC39B/Tricore/Cpu/Std/IfxCpu.c"
  "../Libraries/iLLD/TC39B/Tricore/Pms/Std/IfxPmsEvr.c"
  "../Libraries/Service/CpuGeneric/SysSe/Bsp/Bsp.c"
)

target_include_directories(configurations
  PUBLIC
  "${PROJECT_SOURCE_DIR}/Configurations/"
  "${PROJECT_SOURCE_DIR}/Libraries/Infra/Platform/"
  "${PROJECT_SOURCE_DIR}/Libraries/Infra/Sfr/TC39B/_Reg/"
  "${PROJECT_SOURCE_DIR}/Libraries/Infra/Ssw/TC39B/Tricore"
  "${PROJECT_SOURCE_DIR}/Libraries/Infra/Ssw/TC39B/Tricore"
  "${PROJECT_SOURCE_DIR}/Libraries/iLLD/TC39B/Tricore/Pms/Std/"
  "${PROJECT_SOURCE_DIR}/Libraries/iLLD/TC39B/Tricore/"
  "${PROJECT_SOURCE_DIR}/Libraries/iLLD/TC39B/Tricore/Cpu"
  "${PROJECT_SOURCE_DIR}/Libraries/iLLD/TC39B/Tricore/Scu/Std/"
  "${PROJECT_SOURCE_DIR}/Libraries/Service/CpuGeneric/"
  "./Libraries/Service/CpuGeneric/SysSe/Bsp/"
)


