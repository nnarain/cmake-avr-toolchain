
cmake_minimum_required(VERSION 2.8)

set(AVR_MCU "atmega328p")
set(CMAKE_TOOLCHAIN_FILE "${CMAKE_SOURCE_DIR}/cmake/avr-gcc.toolchain.cmake")

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake/")
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake/Modules/")

project(myproject C CXX ASM)

add_definitions(-DF_CPU=16000000)

include_directories(
	include/
)

add_avr_executable(
	${PROJECT_NAME}

	src/main.cpp
)

target_link_libraries(${PROJECT_NAME} m c gcc)