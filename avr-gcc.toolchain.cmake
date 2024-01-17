
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

            $ENV{AVR_ROOT}
    )

elseif(WIN32)

    set(OS_SUFFIX ".exe")
    find_path(TOOLCHAIN_ROOT
        NAMES
            ${TRIPLE}-gcc${OS_SUFFIX}

        PATHS
            "C:\\WinAVR\\bin"
            $ENV{AVR_ROOT}
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
set(CMAKE_OBJDUMP      "${TOOLCHAIN_ROOT}/${TRIPLE}-objdump${OS_SUFFIX}" CACHE PATH "objdump" FORCE)
set(CMAKE_STRIP        "${TOOLCHAIN_ROOT}/${TRIPLE}-strip${OS_SUFFIX}"   CACHE PATH "strip"   FORCE)
set(CMAKE_RANLIB       "${TOOLCHAIN_ROOT}/${TRIPLE}-ranlib${OS_SUFFIX}"  CACHE PATH "ranlib"  FORCE)
set(AVR_SIZE           "${TOOLCHAIN_ROOT}/${TRIPLE}-size${OS_SUFFIX}"    CACHE PATH "size"    FORCE)

set(CMAKE_EXE_LINKER_FLAGS "-L /usr/lib/gcc/avr/4.8.2")

# avr uploader config
find_program(AVR_UPLOAD
    NAME
        avrdude

    PATHS
        /usr/bin/
        $ENV{AVR_ROOT}
)

# setup the avr exectable macro

set(AVR_LINKER_LIBS "-lc -lm -lgcc -Wl,-lprintf_flt -Wl,-u,vfprintf")

# Macro for adding precompiled libraries
macro(add_avr_libraries target_name avr_mcu)
    target_link_libraries(
        ${target_name}-${avr_mcu}.elf
        ${ARGN}
    )
endmacro()

macro(add_avr_executable target_name avr_mcu)

    set(elf_file ${target_name}-${avr_mcu}.elf)
    set(map_file ${target_name}-${avr_mcu}.map)
    set(hex_file ${target_name}-${avr_mcu}.hex)
    set(lst_file ${target_name}-${avr_mcu}.lst)

    # create elf file
    add_executable(${elf_file}
        ${ARGN}
    )

    set_target_properties(
        ${elf_file}

        PROPERTIES
            COMPILE_FLAGS "-mmcu=${avr_mcu} -g -Os -w -std=gnu++11 -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics"
            LINK_FLAGS    "-mmcu=${avr_mcu} -Wl,-Map,${map_file} ${AVR_LINKER_LIBS}"
    )

    # generate the lst file
    add_custom_command(
        OUTPUT ${lst_file}

        COMMAND
            ${CMAKE_OBJDUMP} -h -S ${elf_file} > ${lst_file}

        DEPENDS ${elf_file}
    )

    # create hex file
    add_custom_command(
        OUTPUT ${hex_file}

        COMMAND
            ${CMAKE_OBJCOPY} -j .text -j .data -O ihex ${elf_file} ${hex_file}

        DEPENDS ${elf_file}
    )

    add_custom_command(
        OUTPUT "print-size-${elf_file}"

        COMMAND
            ${AVR_SIZE} ${elf_file}

        DEPENDS ${elf_file}
    )

    # build the intel hex file for the device
    add_custom_target(
        ${target_name}
        ALL
        DEPENDS ${hex_file} ${lst_file} "print-size-${elf_file}"
    )

    set_target_properties(
        ${target_name}

        PROPERTIES
            OUTPUT_NAME ${elf_file}
    )
endmacro(add_avr_executable)
