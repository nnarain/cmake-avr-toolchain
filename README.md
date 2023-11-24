# CMake AVR Toolchain

A toolchain file for working with `avr-gcc`. Modified from the original branch to add support for precompiled objects and libraries.

Usage
-----

**Requirements**

* AVR toolchain installed on your system (If not in one of the default search paths, specify `$AVR_ROOT`)

Copy `avr-gcc.toolchain.cmake` into your project (or you could use this repo as a submodule). Then set `CMAKE_TOOLCHAIN_FILE`. This can be done from your project's `CMakeLists.txt` file or at the commandline.

The following is an example `CMakeLists.txt` for an `atmega2560` project (Arduino Mega).

```cmake
cmake_minimum_required(VERSION 3.0)

set(CMAKE_TOOLCHAIN_FILE "/path/to/avr-gcc.toolchain.cmake")

project(myproject C CXX ASM)

include_directories(
    include/
)

add_definitions(-DF_CPU=16000000)

add_avr_libraries("${PROJECT_NAME} "atmega2560" 
    ${CMAKE_SOURCE_DIR}/bin/lib.a
    ${CMAKE_SOURCE_DIR}/bin/obj.o
)

add_avr_executable(${PROJECT_NAME} "atmega2560"
    src/main.cpp
)
```

```bash
cmake
# or the following if you want to specify the toolchain file at the command line
cmake -DCMAKE_TOOLCHAIN_FILE=/path/to/avr-gcc.toolchain.cmake
```

**Flash**

```bash
avrdude -v -patmega2560 -cwiring -PCOM6 -b115200 -D -Uflash:w:myproject-atmega2560.hex
```

## Libraries

Optional libraries and precompiled objects can be included through the `add_avr_libraries` macro, which is similar to the `add_avr_executable` macro

```cmake
...

add_avr_libraries("${PROJECT_NAME} "atmega2560" 
    ${CMAKE_SOURCE_DIR}/bin/lib.a
    ${CMAKE_SOURCE_DIR}/bin/obj.o
)
```
