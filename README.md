# Blinky_LED
Demonstrate using open source tricore-gcc toolchain and miniwiggler to *flash* and *debug* a TC397 device

## Device  
The device used in this example is AURIX&trade; TC39xTP_A-Step.

## Board  
The board used for testing is the AURIX&trade; TC397 TFT (KIT_AURIX_TC397_TFT).

## Introduction  
The individual control and data bits of each GPIO port are implemented in a number of registers. The registers are used to configure and use the port as general-purpose I/O.

The port input/output control registers configure the functionality and characteristics of the GPIO port pin such as port direction (input or output), pull-up, pull-down, and push-pull or open-drain functionality.

## Prerequisites
- CMake
- Install [DAS server](https://www.infineon.com/cms/en/product/promopages/das/) the MCD server application
- Install [Aurix Flasher Tool](https://softwaretools.infineon.com/tools/com.ifx.tb.tool.aurixflashersoftwaretool)
- Install [tricore-gcc toolchain](https://github.com/NoMore201/tricore-gcc-toolchain)
- Install [tricore-gdb-das](https://github.com/AkhilTThomas/tricore-gdb-das) MCD - GDB client
- Optional:
  - [just](https://github.com/casey/just) a make style command runner

## Implementation  

### Initialization of the LED

The LED is initialized with the function *IfxPort_setPinModeOutput()* from the iLLD *IfxPort.h*.

The LED is switched off with the function *IfxPort_setPinHigh()* from the iLLD *IfxPort.h*.

### Toggling of the LED

The state of the LED is toggled with the function *IfxPort_togglePin()* from the iLLD *IfxPort.h*.

This state is hold for one second with the function *waitTime()* from the iLLD *Bsp.h*.

## Compiling and programming  
Before testing this code example:  
- Power the board through the dedicated power connector
- Connect the board to the PC through the USB interface
- Compilation steps : 
  ```
  just configure
  just build
## Run and Debug 

- Flashing and Launch GDB server ```tricore-gdb-das --elf_file build\Blinky_Led.elf```
- Debugging :
  From vscode launch ```F5 > Launch miniwiggler```

  <img src="./Images/vscode-gdb-debug.png"/>

## References  

- <https://github.com/Infineon/AURIX_code_examples>
- <https://github.com/NoMore201/aurix-cmake-code-sample>

