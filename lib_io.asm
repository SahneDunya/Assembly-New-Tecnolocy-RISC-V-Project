# lib_io.asm
# ANT Standard Library - Input/Output Module
# Targets RISC-V (Linux ABI assumed for syscalls)

.global ant_print_string
.global ant_print_int
.global ant_read_string # Placeholder

.data
    # Data section for I/O related data
    newline: .string "\n"
    space:   .string " "
    minus_char: .string "-"
    # Buffer for integer to string conversion
    int_buffer_size = 32 # Sufficient for 64-bit integer string representation + sign + null
    int_buffer: .byte 0:int_buffer_size

.text

# ant_print_string: Prints a null-terminated string to standard output.
# Assumes ANT strings are null-terminated for this example.
# Arguments:
# a0: Pointer to the null-terminated string.
# Returns: None
ant_print_string:
    # Function prologue
    addi sp, sp, -16 # Adjust stack pointer
    sd ra, 0(sp)     # Save return address
    sd s0, 8(sp)     # Save s0 (will use for string pointer)
    mv s0, a0        # s0 = string ptr

    # --- Calculate String Length ---
    # Need to find the length of the string first for the write syscall.
    # Can call string_length from utils_compiler.s or implement here.
    # Let's call a hypothetical helper for simplicity in this example.
    # mv a0, s0 # Pass string pointer to length calculator
    # jal string_length_helper # Hypothetical helper
    # mv a2, a0 # a2 = string length (for syscall arg)

    # For this skeleton, let's implement a simple length calculation loop:
    li t0, 0       # t0 = length counter
    mv t1, s0      # t1 = current char pointer
    length_loop:
        lb t2, 0(t1) # Load current character
        beq t2, zero, length_done # If null terminator, done
        addi t0, t0, 1 # Increment length
        addi t1, t1, 1 # Move to next character
        j length_loop
    length_done:
    mv a2, t0 # a2 = length

    # --- Write to Standard Output ---
    li a7, 64           # syscall number for write
    li a0, 1            # file descriptor 1 (stdout)
    mv a1, s0           # a1 = address of string buffer (our string pointer)
    # a2 already holds the length

    ecall               # Perform the system call

    # Function epilogue
    ld ra, 0(sp)     # Restore return address
    ld s0, 8(sp)     # Restore s0
    addi sp, sp, 16  # Restore stack pointer
    jr ra            # Return

# ant_print_int: Prints an integer to standard output.
# Arguments:
# a0: The integer to print (signed 64-bit).
# Returns: None
ant_print_int:
    # Function prologue
    addi sp, sp, -24 # Adjust stack pointer
    sd ra, 0(sp)     # Save return address
    sd s0, 8(sp)     # Save s0 (will use for integer value)
    sd s1, 16(sp)    # Save s1 (will use for buffer end pointer)
    mv s0, a0        # s0 = integer value

    # --- Integer to String Conversion (Simplified) ---
    # Convert the integer in s0 to a string in int_buffer.
    # This is a common algorithm: repeatedly take modulo 10 for digits, divide by 10,
    # handle sign, and build the string in reverse order.

    la s1, int_buffer + int_buffer_size - 1 # s1 points to the last byte of the buffer
    sb zero, 0(s1) # Null terminate the end of the buffer

    # Handle negative numbers
    li t0, 0 # t0 = sign flag (0 for positive, 1 for negative)
    bge s0, zero, .L_start_itoa # If s0 >= 0, jump to conversion
    li t0, 1 # Set sign flag if negative
    neg s0, s0 # Make the number positive for conversion (s0 = -s0)

.L_start_itoa:
    mv a0, s0 # Number to convert
    mv a1, s1 # Buffer end pointer (where to write digits backwards)
    mv a2, t0 # Sign flag
    jal integer_to_string_helper # Hypothetical helper function

    # Assume integer_to_string_helper returns pointer to the start of the string in a0
    mv s0, a0 # s0 now points to the start of the integer string in the buffer

    # --- Print the Integer String ---
    # Call ant_print_string to print the resulting string.
    mv a0, s0 # Pass pointer to the integer string
    jal ant_print_string # Call our string printing function

    # Function epilogue
    ld ra, 0(sp)     # Restore return address
    ld s0, 8(sp)     # Restore s0
    ld s1, 16(sp)    # Restore s1
    addi sp, sp, 24  # Restore stack pointer
    jr ra            # Return

# integer_to_string_helper: Converts an integer to a string in a buffer.
# Arguments:
# a0: The integer value (positive or negative).
# a1: Pointer to the end of the buffer (where to write null terminator initially).
# a2: Sign flag (0 for positive, 1 for negative).
# Returns:
# a0: Pointer to the start of the resulting string in the buffer.
# NOTE: This helper needs to be implemented! It's complex in Assembly.
# It needs to handle the conversion and write backwards from a1, then
# write the sign character if necessary, and finally return the pointer
# to the first character written.

# ant_read_string: Reads a string from standard input.
# Arguments: None (or buffer pointer/size if pre-allocated)
# Returns:
# a0: Pointer to the allocated string buffer containing the read input, or 0 on error.
#     Requires runtime memory allocation for the string.
ant_read_string:
    # Function prologue (Save ra, s0)
    addi sp, sp, -16
    sd ra, 0(sp)
    sd s0, 8(sp)

    # --- Read from Standard Input (Highly Simplified Placeholder) ---
    # 1. Allocate a buffer to read into (Needs memory allocation).
    #    li a0, initial_read_buffer_size # Example size
    #    jal ant_malloc # Use the hypothetical library malloc
    #    mv s0, a0 # s0 holds the buffer pointer
    #    beq s0, zero, read_error # If allocation failed

    # 2. Use the read syscall.
    #    li a7, 63           # syscall number for read
    #    li a0, 0            # file descriptor 0 (stdin)
    #    mv a1, s0           # a1 = buffer address
    #    li a2, initial_read_buffer_size # a2 = max bytes to read
    #    ecall               # Perform the system call
    #    mv t0, a0           # t0 = number of bytes actually read (or error code)

    # 3. Check read result (t0). Handle errors (negative) or EOF (zero).
    #    Handle buffer overflow if input exceeds initial_read_buffer_size (Requires resizing or reading in chunks).
    #    Null-terminate the string in the buffer at the correct position (t0).

    # 4. Return the buffer pointer (s0).

    # For this skeleton, always return 0 (fail read)
    li a0, 0 # Indicate read failure (dummy)

    read_epilogue: # Common exit point
    # Function epilogue (Restore s0, ra)
    ld ra, 0(sp)
    ld s0, 8(sp)
    addi sp, sp, 16
    jr ra

read_error:
    # Handle read error (e.g., print message, free allocated buffer if needed)
    # li a0, ERROR_CODE_READ_FAILED # Hypothetical error code
    # la a1, filename_if_available # Pass filename if relevant
    # li a2, 0 # Line number (N/A for input)
    # li a3, 0 # Column number (N/A for input)
    # jal report_error # Call error reporting
    li a0, 0 # Ensure 0 is returned on error
    j read_epilogue