# type_operations.asm
# ANT Standard Library - Type-Specific Operations Module
# Targets RISC-V

# These functions are called by the COMPILER-GENERATED CODE
# or potentially by the compiler itself for constant evaluation.

.global ant_string_concat     # Concatenate two strings
.global ant_float_compare_eq  # Compare two floats for equality
.global ant_float_compare_lt  # Compare two floats for less than
.global ant_copy_struct       # Copy data for a struct

.text

# ant_string_concat: Concatenates two strings into a new allocated string.
# Arguments:
# a0: Pointer to the first string.
# a1: Pointer to the second string.
# Returns:
# a0: Pointer to the newly allocated concatenated string, or 0 on failure.
# The caller takes ownership of the new string.
ant_string_concat:
    # Function prologue (Save ra, s0, s1)
    addi sp, sp, -24
    sd ra, 0(sp)
    sd s0, 8(sp) # str1 ptr
    sd s1, 16(sp) # str2 ptr
    mv s0, a0 # s0 = str1
    mv s1, a1 # s1 = str2

    # --- Concatenation Logic ---
    # 1. Get lengths of str1 and str2 (call ant_string_length).
    # 2. Calculate total size needed (len1 + len2 + 1 for null terminator).
    # 3. Allocate memory for the result (call ant_malloc). Check allocation error.
    # 4. Copy str1 to the result buffer (call ant_memcpy).
    # 5. Copy str2 to the result buffer immediately after str1 (call ant_memcpy).
    # 6. Null-terminate the result buffer.
    # 7. Return pointer to the result (a0).

    # For this skeleton, always return 0 (failure)
    li a0, 0 # Indicate failure

    # Function epilogue (Restore s1, s0, ra)
    ld ra, 0(sp)
    ld s0, 8(sp)
    ld s1, 16(sp)
    addi sp, sp, 24
    jr ra

# ant_float_compare_eq: Compares two floating-point numbers for equality.
# Arguments:
# fa0: First float value (in floating-point register).
# fa1: Second float value (in floating-point register).
# Returns:
# a0: Boolean result (1 for true, 0 for false).
# NOTE: Requires RISC-V F or D extension for floating-point instructions.
ant_float_compare_eq:
    # Function prologue (Save ra, s0 if using integer regs, or fs0/fs1 if using float regs)
    addi sp, sp, -8
    sd ra, 0(sp)
    # No integer regs saved here as we only use float compare and int return

    # --- Float Compare Logic ---
    # Use feq.d instruction for double-precision (requires D extension)
    # feq.d rd, rs1, rs2 -> rd = (rs1 == rs2) ? 1 : 0
    # or feq.s for single-precision (requires F extension)
    # feq.s rd, rs1, rs2 -> rd = (rs1 == rs2) ? 1 : 0

    # Assuming double-precision (D extension)
    feq.d a0, fa0, fa1 # Compare fa0 and fa1, store boolean result in a0 (integer register)

    # Function epilogue
    ld ra, 0(sp)
    addi sp, sp, 8
    jr ra

# ant_float_compare_lt: Compares two floating-point numbers for less than.
# Arguments:
# fa0: First float value.
# fa1: Second float value.
# Returns:
# a0: Boolean result (1 for true, 0 for false).
# NOTE: Requires RISC-V F or D extension.
ant_float_compare_lt:
    # Function prologue (Save ra)
    addi sp, sp, -8
    sd ra, 0(sp)

    # --- Float Compare Logic ---
    # Use flt.d instruction for double-precision
    # flt.d rd, rs1, rs2 -> rd = (rs1 < rs2) ? 1 : 0
    # or flt.s for single-precision
    # flt.s rd, rs1, rs2 -> rd = (rs1 < rs2) ? 1 : 0

    # Assuming double-precision (D extension)
    flt.d a0, fa0, fa1 # Compare fa0 and fa1, store boolean result in a0

    # Function epilogue
    ld ra, 0(sp)
    addi sp, sp, 8
    jr ra

# ant_copy_struct: Copies data for a struct from source to destination.
# Arguments:
# a0: Destination pointer (for the struct).
# a1: Source pointer (for the struct).
# a2: Size of the struct in bytes.
# Returns:
# a0: Destination pointer.
ant_copy_struct:
    # This is a simple wrapper around ant_memcpy
    # Function prologue (Save ra)
    addi sp, sp, -8
    sd ra, 0(sp)

    # Arguments are already in a0, a1, a2 for ant_memcpy
    jal ant_memcpy # Call the memory copy routine

    # ant_memcpy returns the destination pointer in a0, which is what we need.

    # Function epilogue
    ld ra, 0(sp)
    addi sp, sp, 8
    jr ra

# --- Other potential type-specific operations (Need implementation) ---
# Integer: division/modulo (if not direct instructions, or for specific semantics)
# Boolean: logical NOT (if not direct instruction)
# Pointers: pointer arithmetic (if not direct instructions), pointer comparison
# Arrays: element access (already in lib_data_structures.s), slicing, creation, resizing
# Structs: member access (handled by code generator offset calculation), copying (done here)
# ... operations related to Ownership/Borrowing if they require runtime checks (less likely for Rust-like model) ...