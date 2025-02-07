set(CMAKE_SYSTEM_NAME Generic)

set(CMAKE_C_FLAGS_DEBUG "-g -O0")
set(CMAKE_C_FLAGS_RELEASE "-O2")
set(CMAKE_C_FLAGS_RELWITHDEBINFO "-O2 -g")
set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG}")
set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE}")
set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_C_FLAGS_RELWITHDEBINFO}")

# which compilers to use for C and C++
set(CMAKE_C_COMPILER tricore-elf-gcc)
set(CMAKE_CXX_COMPILER tricore-elf-g++)

# Set this to fix errors when testing C compiler
set(CMAKE_TRY_COMPILE_TARGET_TYPE "STATIC_LIBRARY")

# Infineon lib requires __HIGHTEC__ token to be defined when using Tricore
# GCC, but the open source version does not provide such definition. Here
# we force it to avoid issues
add_compile_definitions(__HIGHTEC__)

