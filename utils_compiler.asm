# utils_compiler.asm
# ANT Compiler - Utility Functions Module
# Targets RISC-V

.global string_compare
.global string_length
.global string_copy
.global mem_alloc   # Basic allocator for compiler internal use
.global mem_free    # Basic deallocator

.data
    # Data section for utilities (e.g., memory allocator state if any)
    # Example: Simple bump allocator state
    # heap_start: .byte 0:4096 # Small heap for compiler internal data
    # heap_current_ptr: .word heap_start

.text

# string_compare: Compares two null-terminated strings.
# Arguments:
# a0: Pointer to string 1.
# a1: Pointer to string 2.
# Returns:
# a0: 0 if strings are equal, negative if s1 < s2, positive if s1 > s2.
string_compare:
    # Function prologue
    addi sp, sp, -16 # Save ra, s0
    sd ra, 0(sp)
    sd s0, 8(sp)
    mv s0, a0 # s0 = ptr1
    mv s1, a1 # s1 = ptr2

    # --- String Compare Logic ---
    # compare_loop:
    #    lb t0, 0(s0) # Load byte from ptr1
    #    lb t1, 0(s1) # Load byte from ptr2
    #
    #    beq t0, t1, check_end # If bytes are equal, check if end of string
    #
    #    # If bytes are not equal, return difference
    #    sub a0, t0, t1 # a0 = byte1 - byte2
    #    j compare_epilogue # Jump to epilogue
    #
    # check_end:
    #    beq t0, zero, equal_and_end # If both bytes were zero, end of strings
    #
    #    # If bytes were equal but not zero, move to next character
    #    addi s0, s0, 1
    #    addi s1, s1, 1
    #    j compare_loop # Continue loop

    # equal_and_end:
    #    li a0, 0 # Return 0 (strings are equal)

    # For this skeleton, just return 0
    li a0, 0 # Assume equal (dummy)

    # Common epilogue
    compare_epilogue:
    # Function epilogue
    ld ra, 0(sp)
    ld s0, 8(sp)
    addi sp, sp, 16
    jr ra

# string_length: Calculates the length of a null-terminated string.
# Arguments:
# a0: Pointer to the string.
# Returns:
# a0: Length of the string (excluding null terminator).
string_length:
    # Function prologue
    addi sp, sp, -16 # Save ra, s0
    sd ra, 0(sp)
    sd s0, 8(sp)
    mv s0, a0 # s0 = string ptr

    # --- String Length Logic ---
    # li t0, 0 # t0 = counter (length)
    # length_loop:
    #    lb t1, 0(s0) # Load byte
    #    beq t1, zero, length_end # If null terminator, end loop
    #    addi t0, t0, 1 # Increment counter
    #    addi s0, s0, 1 # Move to next character
    #    j length_loop # Continue loop
    #
    # length_end:
    #    mv a0, t0 # Return counter (length)

    # For this skeleton, just return 0
    li a0, 0 # Assume length 0 (dummy)

    # Function epilogue
    ld ra, 0(sp)
    ld s0, 8(sp)
    addi sp, sp, 16
    jr ra

# string_copy: Copies a null-terminated string from source to destination.
# Arguments:
# a0: Pointer to the destination buffer.
# a1: Pointer to the source string.
# Returns: None (or pointer to destination)
string_copy:
    # Function prologue
    addi sp, sp, -16 # Save ra, s0
    sd ra, 0(sp)
    sd s0, 8(sp)
    mv s0, a0 # s0 = dest ptr
    mv s1, a1 # s1 = src ptr

    # --- String Copy Logic ---
    # copy_loop:
    #    lb t0, 0(s1) # Load byte from source
    #    sb t0, 0(s0) # Store byte to destination
    #    beq t0, zero, copy_end # If null terminator, end loop
    #    addi s0, s0, 1 # Move destination pointer
    #    addi s1, s1, 1 # Move source pointer
    #    j copy_loop # Continue loop
    #
    # copy_end:
    #    # Done copying

    # Function epilogue
    ld ra, 0(sp)
    ld s0, 8(sp)
    addi sp, sp, 16
    jr ra

# mem_alloc: Basic memory allocation for compiler's internal data.
# This is NOT the ANT language's ownership/borrowing memory management.
# Arguments:
# a0: Size of memory block requested in bytes.
# Returns:
# a0: Pointer to the allocated memory block, or 0 on failure.
mem_alloc:
    # Function prologue
    addi sp, sp, -8 # Save ra
    sd ra, 0(sp)

    # --- Basic Allocation Logic (Example: Simple Bump Allocator) ---
    # la t0, heap_current_ptr # Address of the current pointer
    # ld t1, 0(t0) # t1 = current heap pointer
    #
    # mv a0, t1 # Return the current pointer as the allocated block start
    #
    # add t1, t1, a0 # Calculate next heap pointer (current + requested size) - Check for overflow/heap end!
    # # Need to check if t1 exceeds heap_start + heap_size
    #
    # sd t1, 0(t0) # Update heap_current_ptr

    # For this skeleton, always return 0 (fail allocation)
    li a0, 0 # Indicate allocation failure (dummy)

    # Function epilogue
    ld ra, 0(sp)
    addi sp, sp, 8
    jr ra

# mem_free: Basic memory deallocation for compiler's internal data.
# For a simple bump allocator, this might do nothing.
# Arguments:
# a0: Pointer to the memory block to free.
# Returns: None
mem_free:
    # Function prologue
    addi sp, sp, -8 # Save ra
    sd ra, 0(sp)

    # --- Deallocation Logic (Simple Bump Allocator does nothing here) ---
    # If using a more complex allocator (free lists, etc.), implement freeing here.

    # Function epilogue
    ld ra, 0(sp)
    addi sp, sp, 8
    jr ra

# --- Other Utility Helpers (Need implementation) ---
# integer_to_string: Convert integer to ASCII string.
# string_equals: Wrapper for string_compare == 0.
# is_whitespace: Check if a character is whitespace.
# is_digit: Check if a character is a digit.
# is_alpha: Check if a character is alphabetic.
# ... etc.