# pm_utils.asm
# ANT Packet Manager - Utility Functions Module
# Targets RISC-V

.global pm_string_equals # Check if two strings are equal
.global pm_get_argument  # Get argument string by index from argv
.global pm_join_paths    # Placeholder - Join two path components

.text

# pm_string_equals: Checks if two null-terminated strings are equal.
# Arguments:
# a0: Pointer to string 1.
# a1: Pointer to string 2.
# Returns:
# a0: 0 if strings are equal, non-zero otherwise.
pm_string_equals:
    # This is a simple wrapper around string_compare from lib_string.s or utils_compiler.s
    # Function prologue
    addi sp, sp, -8 # Save ra
    sd ra, 0(sp)

    # Call string_compare (assuming it returns 0 for equal)
    jal ant_string_compare # Hypothetical call to ant_string_compare

    # a0 now holds the result of string_compare. We need 0 for equal, non-zero otherwise.
    # string_compare returns 0 for equal, negative for <, positive for >.
    # So, just return a0 directly.

    # Function epilogue
    ld ra, 0(sp)
    addi sp, sp, 8
    jr ra

# pm_get_argument: Gets the Nth command-line argument string.
# Arguments:
# a0: Pointer to the argv array (from _start).
# a1: Index of the desired argument (0-based).
# Returns:
# a0: Pointer to the argument string, or 0 if index is out of bounds (>= argc).
pm_get_argument:
    # Function prologue
    addi sp, sp, -16 # Save ra, s0
    sd ra, 0(sp)
    sd s0, 8(sp)
    mv s0, a0 # s0 = argv ptr

    # --- Get Argument Logic ---
    # Need argc to check bounds. argc is usually in a0 at _start.
    # We need to pass argc into this function or get it another way.
    # Let's assume argc is available somewhere or passed in another register.
    # For this skeleton, we won't check bounds against argc.

    # Calculate the address of the desired argument pointer in the argv array.
    # Arguments in argv are pointers, each 8 bytes on RV64.
    slli t0, a1, 3 # t0 = index * 8
    add t1, s0, t0 # t1 = address of the pointer to the argument string

    # Load the argument string pointer from the argv array.
    ld a0, 0(t1) # a0 = pointer to the argument string

    # Function epilogue
    ld ra, 0(sp)
    ld s0, 8(sp)
    addi sp, sp, 16
    jr ra

# pm_join_paths: Joins two path components with a directory separator.
# Example: join_paths("dir", "file") -> "dir/file"
# Requires dynamic memory allocation for the result string.
# Arguments:
# a0: Pointer to the first path component string.
# a1: Pointer to the second path component string.
# Returns:
# a0: Pointer to the newly allocated joined path string, or 0 on failure.
# The caller takes ownership of the allocated string.
pm_join_paths:
    # Function prologue (Save ra, s0, s1)
    addi sp, sp, -24
    sd ra, 0(sp)
    sd s0, 8(sp) # path1 ptr
    sd s1, 16(sp) # path2 ptr

    mv s0, a0 # s0 = path1
    mv s1, a1 # s1 = path2

    # --- Join Paths Logic (Highly Simplified Placeholder) ---
    # 1. Get length of path1 (pm_string_length or ant_string_length).
    # 2. Get length of path2.
    # 3. Calculate total size needed: len1 + len2 + 1 (separator) + 1 (null terminator).
    # 4. Allocate memory for the result string (ant_malloc or similar). Check allocation error.
    # 5. Copy path1 to the result buffer (pm_string_copy or ant_memcpy).
    # 6. Append directory separator ('/') to the result buffer.
    # 7. Append path2 to the result buffer.
    # 8. Null-terminate the result buffer.
    # 9. Return pointer to the result buffer (a0).

    # For this skeleton, return 0 (failure)
    li a0, 0 # Indicate failure

    # Function epilogue (Restore s1, s0, ra)
    ld ra, 0(sp)
    ld s0, 8(sp)
    ld s1, 16(sp)
    addi sp, sp, 24
    jr ra

# --- Other Utility Helpers (Need implementation) ---
# print_string_helper: Helper to print a string (for usage/error messages - wrapper for write syscall or lib_io.s).
# pm_parse_int: Parse a string as an integer.
# ...