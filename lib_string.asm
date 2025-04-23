# lib_string.asm
# ANT Standard Library - String Module
# Targets RISC-V

.global ant_string_length
.global ant_string_copy    # Returns owned copy
.global ant_string_compare

.text

# ant_string_length: Calculates the length of a null-terminated string.
# Assumes ANT strings are null-terminated.
# Arguments:
# a0: Pointer to the null-terminated string.
# Returns:
# a0: Length of the string (excluding null terminator).
ant_string_length:
    # This is the same logic as the helper in lib_io.asm or utils_compiler.s
    # Can call the helper or implement here again. Let's implement here.
    # Function prologue
    addi sp, sp, -16
    sd ra, 0(sp)
    sd s0, 8(sp)
    mv s0, a0 # s0 = string ptr

    li t0, 0 # t0 = length counter
    length_loop:
        lb t1, 0(s0) # Load current character
        beq t1, zero, length_done # If null terminator, done
        addi t0, t0, 1 # Increment length
        addi s0, s0, 1 # Move to next character
        j length_loop
    length_done:
    mv a0, t0 # a0 = length

    # Function epilogue
    ld ra, 0(sp)
    ld s0, 8(sp)
    addi sp, sp, 16
    jr ra

# ant_string_copy: Creates an owned copy of a null-terminated string.
# The caller takes ownership of the newly allocated string.
# Arguments:
# a0: Pointer to the source string.
# Returns:
# a0: Pointer to the newly allocated copy, or 0 on allocation failure.
ant_string_copy:
    # Function prologue
    addi sp, sp, -16
    sd ra, 0(sp)
    sd s0, 8(sp)
    mv s0, a0 # s0 = source string ptr

    # --- Copy Logic ---
    # 1. Get the length of the source string.
    #    mv a0, s0 # Pass source pointer to length function
    #    jal ant_string_length # Call our length function
    #    mv t0, a0 # t0 = string length

    # 2. Calculate size needed for the copy (length + 1 for null terminator).
    #    addi t0, t0, 1 # Add 1 for null terminator

    # 3. Allocate memory for the new string (Needs runtime memory allocation).
    #    mv a0, t0 # Pass size to allocation function
    #    jal ant_malloc # Call hypothetical library malloc
    #    mv s1, a0 # s1 = destination buffer pointer
    #    beq s1, zero, copy_error # If allocation failed, jump to error

    # 4. Copy the source string (s0) to the destination buffer (s1), including the null terminator.
    #    mv a0, s1 # Pass dest ptr
    #    mv a1, s0 # Pass src ptr
    #    # Use string_copy_helper or implement inline (similar to utils_compiler.s)
    #    copy_loop: # Implementing inline for example
    #       lb t2, 0(s0) # Load byte from source
    #       sb t2, 0(s1) # Store byte to destination
    #       beq t2, zero, copy_done # If null terminator, end loop
    #       addi s0, s0, 1 # Move source pointer
    #       addi s1, s1, 1 # Move destination pointer
    #       j copy_loop
    #    copy_done:

    # 5. Return the pointer to the newly allocated string (s1).
    #    mv a0, s1

    # For this skeleton, always return 0 (fail allocation)
    li a0, 0 # Indicate allocation failure (dummy)
    j copy_epilogue # Jump to common epilogue

copy_error:
    # Handle copy error (e.g., allocation failed)
    # Report error
    li a0, 0 # Ensure 0 is returned on error

copy_epilogue: # Common exit point
    # Function epilogue
    ld ra, 0(sp)
    ld s0, 8(sp)
    addi sp, sp, 16
    jr ra

# ant_string_compare: Compares two null-terminated strings.
# Arguments:
# a0: Pointer to string 1.
# a1: Pointer to string 2.
# Returns:
# a0: 0 if strings are equal, negative if s1 < s2, positive if s1 > s2.
ant_string_compare:
    # This is the same logic as string_compare in utils_compiler.s
    # Can call the helper or implement here again. Let's implement here.
    # Function prologue
    addi sp, sp, -16
    sd ra, 0(sp)
    sd s0, 8(sp)
    mv s0, a0 # s0 = ptr1
    mv s1, a1 # s1 = ptr2

    # --- String Compare Logic ---
    compare_loop:
        lb t0, 0(s0) # Load byte from ptr1
        lb t1, 0(s1) # Load byte from ptr2

        beq t0, t1, check_end # If bytes are equal, check if end of string

        # If bytes are not equal, return difference
        sub a0, t0, t1 # a0 = byte1 - byte2
        j compare_epilogue # Jump to epilogue

    check_end:
        beq t0, zero, equal_and_end # If both bytes were zero, end of strings

        # If bytes were equal but not zero, move to next character
        addi s0, s0, 1
        addi s1, s1, 1
        j compare_loop # Continue loop

    equal_and_end:
        li a0, 0 # Return 0 (strings are equal)

    compare_epilogue: # Common exit point
    # Function epilogue
    ld ra, 0(sp)
    ld s0, 8(sp)
    addi sp, sp, 16
    jr ra

# --- Helper Routines (Need implementation) ---
# integer_to_string_helper: (Needed by ant_print_int)
# ant_malloc: (Needed by ant_read_string and ant_string_copy) - Could be in lib_core.s
# ant_free: (Needed by ant_read_string if reallocation fails, or by the language's memory management)
# ...