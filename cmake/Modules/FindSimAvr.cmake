
#
# Find SimAVR include files
#
# \author Natesh Narain
#

find_path(SIMAVR_INCLUDE_DIR
	NAMES
		"simavr/avr/avr_mcu_section.h"

	PATHS
		/usr/include/
		/usr/local/include/
)

# macro to generate C source file with VCD trace data
macro(add_vcd_trace target_name mcu clock_speed)
	message("-- Generating ${target_name} VCD trace file for ${mcu}")

	set(trace_list)

	foreach(arg ${ARGN})

		# break down argument string
		string(REPLACE "," ";" arg_list ${arg})

		list(GET arg_list 0 symbol_name)
		list(GET arg_list 1 mask)
		list(GET arg_list 2 what)

		list(APPEND trace_list "\t{ AVR_MCU_VCD_SYMBOL(\"${symbol_name}\"), .mask = (1 << ${mask}), .what = (void*)&${what}, },\n")

	endforeach(arg ${ARGN})

	string(REPLACE ";" " " trace_list ${trace_list})

	set(FILENAME "${target_name}_${mcu}_vcd_trace.c")
	set(TRACE_FILE "${CMAKE_BINARY_DIR}/${FILENAME}")
	file(WRITE ${TRACE_FILE}
		"// Auto generated file by cmake\n"
		"// Generated VCD trace info for ${mcu} with clock speed ${clock_speed}\n\n"

		"#include <avr/io.h>\n"

		"#include <simavr/avr/avr_mcu_section.h>\n\n"
		"AVR_MCU(${clock_speed}, \"${AVR_MCU}\");\n\n"

		"const struct avr_mmcu_vcd_trace_t _mytrace[] _MMCU_ = {\n"
		"${trace_list}"
		"};\n"
	)

	set("${target_name}_VCD_TRACE_FILE" ${TRACE_FILE})

endmacro(add_vcd_trace)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(
	SIMAVR
	DEFAULT_MSG
	SIMAVR_INCLUDE_DIR
)