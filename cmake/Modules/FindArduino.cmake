
#
# Find Arduino Core
#
#
# @author Natesh Narain
# @since Feb 03 2016

# Find Arduino version file
file(GLOB
	ARDUINO_VERSION_FILES

	/usr/share/arduino/lib/version.txt
	/usr/share/arduino-*/lib/version.txt
)

if(NOT ARDUINO_VERSION_FILES)
	message(FATAL_ERROR "Arduino Core could not be found")
endif(NOT ARDUINO_VERSION_FILES)

set(ARDUINO_VERSION_NUMBER 0)
set(ARDUINO_VERSION_TEXT "")
set(ARDUINO_VERSION_FILE "")

# determine the latest version available
foreach(versionFile ${ARDUINO_VERSION_FILES})

	# get version number from the text file
	file(READ ${versionFile} VERSION_TEXT)

	# remove the dots to make it a number
	string(REPLACE "." "" VERSION_NUMBER ${VERSION_TEXT})

	if(${VERSION_NUMBER} GREATER ${ARDUINO_VERSION_NUMBER})

		set(ARDUINO_VERSION_NUMBER ${VERSION_NUMBER})
		set(ARDUINO_VERSION_TEXT ${VERSION_TEXT})
		set(ARDUINO_VERSION_FILE ${versionFile})

	endif(${VERSION_NUMBER} GREATER ${ARDUINO_VERSION_NUMBER})

endforeach(versionFile)

# get arduino root
string(REPLACE "/lib//version.txt" "" ARDUINO_ROOT ${ARDUINO_VERSION_FILE})

# arduino folder locations

set(ARDUINO_LIB_ROOT "${ARDUINO_ROOT}/libraries")
set(ARDUINO_AVR_ROOT "${ARDUINO_ROOT}hardware/arduino/avr/")
set(ARDUINO_CORE "${ARDUINO_AVR_ROOT}cores/arduino/")
set(ARDUINO_VARIANT_ROOT "${ARDUINO_AVR_ROOT}variants/standard")

set(ARDUINO_INCLUDE_DIR ${ARDUINO_CORE} ${ARDUINO_VARIANT_ROOT})

file(GLOB ARDUINO_CORE_SOURCES 
	${ARDUINO_CORE}*.cpp
	${ARDUINO_CORE}*.c
)
message("package: sources: ${ARDUINO_CORE_SOURCES}")

# finished finding package requirements
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(
	ARDUINO
	DEFAULT_MSG
	ARDUINO_ROOT
	ARDUINO_VERSION_NUMBER
	ARDUINO_LIB_ROOT
	ARDUINO_INCLUDE_DIR
	ARDUINO_CORE_SOURCES
)