# lib_api.asm
# ANT Standard Library - API Definition
# Targets RISC-V
# This file declares the public interface of the ANT Standard Library.
# It is primarily used by the ANT compiler.

# --- Global Declarations for Standard Library Functions ---
# These directives make the functions defined in other lib_*.asm files
# visible to the linker and callable from compiler-generated code.

.global ant_exit          # Defined in lib_core.asm
.global ant_print_string  # Defined in lib_io.asm
.global ant_print_int     # Defined in lib_io.asm
.global ant_read_string   # Defined in lib_io.asm (Placeholder)

.global ant_string_length # Defined in lib_string.asm
.global ant_string_copy   # Defined in lib_string.asm
.global ant_string_compare # Defined in lib_string.asm

.global ant_memcpy        # Defined in lib_mem.asm
.global ant_memset        # Defined in lib_mem.asm

.global ant_abs_int       # Defined in lib_math.asm
.global ant_max_int       # Defined in lib_math.asm
.global ant_min_int       # Defined in lib_math.asm

.global ant_array_get     # Defined in lib_data_structures.asm

# --- Standard Library Constants and Data Structure Layouts ---
# Define any constants or data structures that the compiler needs
# to interact correctly with the library functions or internal data.

# Example: Standard file descriptors (Linux ABI)
.equ STDIN, 0
.equ STDOUT, 1
.equ STDERR, 2

# Example: ANT String representation (if not null-terminated, e.g., length-prefixed)
# If string is length-prefixed:
# struct ant_string {
#   uint64 length; # Length of the string data
#   byte[] data;   # The string bytes
# };
# In this case, lib_string functions would work with this structure.
# The compiler would need to know the offset of the length field:
# .equ ANT_STRING_LEN_OFFSET, 0
# .equ ANT_STRING_DATA_OFFSET, 8

# Example: Boolean representation
# .equ ANT_BOOL_TRUE, 1
# .equ ANT_BOOL_FALSE, 0

# --- API Documentation (in comments) ---
# Add comments here documenting each function's purpose,
# expected arguments (in which registers), return value (in which registers),
# and any side effects or assumptions (e.g., ownership transfer).

# ant_exit(a0: exit_code: int) -> never:
#   Terminates the program with the given exit code.

# ant_print_string(a0: str_ptr: *u8) -> ():
#   Prints a null-terminated string to standard output.
#   Takes a pointer to the string data. Does NOT take ownership.

# ant_print_int(a0: value: int) -> ():
#   Prints an integer value to standard output.

# ... and so on for all global functions ...

# This file is typically not assembled directly into the final executable
# but is used by the compiler to know which symbols are available and how to call them.
# The assembler/linker combine the compiled ANT code with the assembled library files.