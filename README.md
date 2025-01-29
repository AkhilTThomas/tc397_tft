# Blinky_LED

Demonstrate using open source tricore-gcc toolchain and miniwiggler
howto to *flash* and *debug* a TC397 device.

The primary motivation was to use a miniwiggler to do a basic debugging on aurix devices. Compared to expensive solutions like Lauterbach and UDE
this is much cheaper to perform a basic debugging and flashing.

## Device  

The device used in this example is AURIX&trade; TC39xTP_A-Step.

## Board  

The board used for testing is the AURIX&trade; TC397 TFT (KIT_AURIX_TC397_TFT).

## Introduction  

The individual control and data bits of each GPIO port are implemented in a number of registers.
The registers are used to configure and use the port as general-purpose I/O.

The port input/output control registers configure the functionality and characteristics of the GPIO port
pin such as port direction (input or output), pull-up, pull-down, and push-pull or open-drain functionality.

## Prerequisites

- CMake
- Download the following into the [.devcontainer](/.devcontainer) folder  
  - [DAS server](https://www.infineon.com/cms/en/product/promopages/das/) the MCD server application  
  - [Aurix Flasher Tool](https://softwaretools.infineon.com/tools/com.ifx.tb.tool.aurixflashersoftwaretool)  
- All subsequent dependencies are dockerized  
- Copy the [udev rules](./.vscode/99-miniwiggler-tricore.rules) into `/etc/udev/rules.d/`  
  This will ensure that the miniwiggler is attached to a `plugdev` user group. If such a group does not exist create it.

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

> [!NOTE]
> Windows users can use [wsl-usb-manager](https://github.com/nickbeth/wsl-usb-manager) to attach the device to WSL2, the docker container runs in
privilege mode and can see all the usb devices.

- Launch repo in container
- Compilation steps :

  ```shell
  just configure
  just build
  just flash

## Run and Debug

- Flashing and Launch GDB server ```tricore-gdb-das --elf_file build\Blinky_Led.elf```
- Debugging :
  From vscode launch ```F5 > Launch miniwiggler```  
  tricore-gdb-das is launched automatically as a `PreLaunchTask`

  <img src="./Images/vscode-gdb-debug.png"/>

## References  

- <https://github.com/Infineon/AURIX_code_examples>
- <https://github.com/NoMore201/aurix-cmake-code-sample>
