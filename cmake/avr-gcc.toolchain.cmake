
#
# AVR GCC Toolchain file
#
# @author Natesh Narain
# @since Feb 06 2016

set(TRIPLE "avr")

# find the toolchain root directory

if(UNIX)

	set(OS_SUFFIX "")
	find_path(TOOLCHAIN_ROOT
		NAMES
			${TRIPLE}-gcc${OS_SUFFIX}

		PATHS
			/usr/bin/
			/usr/local/bin
			/bin/
	)

elseif(WIN32)

	set(OS_SUFFIX ".exe")
	find_path(TOOLCHAIN_ROOT
		NAMES
			${TRIPLE}-gcc${OS_SUFFIX}

		PATHS
			C:\WinAVR\bin
	)

else(UNIX)
	message(FATAL_ERROR "toolchain not supported on this OS")
endif(UNIX)

if(NOT TOOLCHAIN_ROOT)
	message(FATAL_ERROR "Toolchain root could not be found!!!")
endif(NOT TOOLCHAIN_ROOT)

# setup the AVR compiler variables

set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR avr)
set(CMAKE_CROSS_COMPILING 1)

set(CMAKE_C_COMPILER   "${TOOLCHAIN_ROOT}/${TRIPLE}-gcc${OS_SUFFIX}"     CACHE PATH "gcc"     FORCE)
set(CMAKE_CXX_COMPILER "${TOOLCHAIN_ROOT}/${TRIPLE}-g++${OS_SUFFIX}"     CACHE PATH "g++"     FORCE)
set(CMAKE_AR           "${TOOLCHAIN_ROOT}/${TRIPLE}-ar${OS_SUFFIX}"      CACHE PATH "ar"      FORCE)
set(CMAKE_LINKER       "${TOOLCHAIN_ROOT}/${TRIPLE}-ld${OS_SUFFIX}"      CACHE PATH "linker"  FORCE)
set(CMAKE_NM           "${TOOLCHAIN_ROOT}/${TRIPLE}-nm${OS_SUFFIX}"      CACHE PATH "nm"      FORCE)
set(CMAKE_OBJCOPY      "${TOOLCHAIN_ROOT}/${TRIPLE}-objcopy${OS_SUFFIX}" CACHE PATH "objcopy" FORCE)
set(CMAKE_OBJDUMP      "${TOOLCHAIN_ROOT}/${TRIPLE}-objcopy${OS_SUFFIX}" CACHE PATH "objdump" FORCE)
set(CMAKE_STRIP        "${TOOLCHAIN_ROOT}/${TRIPLE}-strip${OS_SUFFIX}"   CACHE PATH "strip"   FORCE)
set(CMAKE_RANLIB       "${TOOLCHAIN_ROOT}/${TRIPLE}-ranlib${OS_SUFFIX}"  CACHE PATH "ranlib"  FORCE)

set(BASE_FLAGS "-Wa,-alh")

set(MCU "atmega328p")
set(TARGET_FLAGS "-mmcu=${MCU}")
set(AVR_LINKER_LIBS "-lm -lc")

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g -Wa,-alH")

macro(avr_mcu mcu)
	set(AVR_MCU ${mcu})
endmacro(avr_mcu)

macro(add_avr_executable target_name)

	set(elf_file ${target_name}-${MCU}.elf)
	set(map_file ${target_name}-${MCU}.map)
	set(hex_file ${target_name}-${MCU}.hex)
	set(lst_file ${target_name}-${MCU}.lst)
	set(asm_file ${target_name}-${MCU}.asm)

	# create elf file
	add_executable(${elf_file}
		${ARGN}
	)

	set_target_properties(
		${elf_file}

		PROPERTIES
			COMPILE_FLAGS "-g -mmcu=${AVR_MCU}"
			LINK_FLAGS    "-Wl,-Map,${map_file}"
	)

	# create hex file
	add_custom_command(
		OUTPUT ${hex_file}

		COMMAND
			${CMAKE_OBJCOPY} -j .text -j .data -O ihex ${elf_file} ${hex_file}

		DEPENDS ${elf_file}
	)

	# build the intel hex file for the device
	add_custom_target(
		${target_name}
		ALL
		DEPENDS ${hex_file}
	)

	set_target_properties(
		${target_name}

		PROPERTIES
			OUTPUT_NAME ${elf_file}
	)

endmacro(add_avr_executable)