# runtime_errors.asm
# ANT Standard Library - Runtime Error Handling
# Targets RISC-V (Linux ABI assumed)
# Handles errors that occur during program execution.

.global handle_div_by_zero  # Example specific error handler
.global ant_panic           # General panic/runtime error handler

.data
    # Data section for runtime error messages
    runtime_error_prefix: .string "Runtime Error: "
    runtime_error_prefix_len = . - runtime_error_prefix

    div_by_zero_msg:   .string "Division by zero!\n"
    div_by_zero_len = . - div_by_zero_msg

    panic_msg:         .string "Panic at runtime!\n" # General panic message
    panic_len = . - panic_msg

    # --- Other potential runtime error messages ---
    # out_of_bounds_msg: .string "Index out of bounds!\n"
    # null_dereference_msg: .string "Null pointer dereference!\n"
    # ...

.text

# handle_div_by_zero: Handles a division by zero runtime error.
# Called by the code generated for division if the divisor is zero.
# Arguments: None (or maybe location info like file/line)
# Returns: Does not return (calls exit).
handle_div_by_zero:
    # Function prologue (Save ra, s0 if needed, though exiting)
    addi sp, sp, -8
    sd ra, 0(sp)

    # --- Print Error Message ---
    # Use syscalls directly or via syscalls.asm wrappers
    # Print prefix
    mv a0, STDERR # fd
    la a1, runtime_error_prefix # buffer
    li a2, runtime_error_prefix_len # count
    li a7, SYS_WRITE # syscall number
    ecall

    # Print specific error message
    mv a0, STDERR # fd
    la a1, div_by_zero_msg # buffer
    li a2, div_by_zero_len # count
    li a7, SYS_WRITE # syscall number
    ecall

    # --- Exit Program ---
    li a0, 1 # Exit code 1 (error)
    li a7, SYS_EXIT # syscall number
    ecall
    # Should not reach here

# ant_panic: General panic handler.
# Called by generated code or library functions on unrecoverable errors.
# Arguments: Maybe a message string pointer (a0) or an error code.
# Returns: Does not return (calls exit).
ant_panic:
    # Function prologue (Save ra if needed, though exiting)
    addi sp, sp, -8
    sd ra, 0(sp)

    # --- Print Error Message ---
    # Print prefix
    mv a0, STDERR
    la a1, runtime_error_prefix
    li a2, runtime_error_prefix_len
    li a7, SYS_WRITE
    ecall

    # Print general panic message (or use the argument message if provided)
    # If a0 contains a custom message pointer:
    # mv a0, STDERR; mv a1, a0; jal string_length_helper; mv a2, a0; li a7, SYS_WRITE; ecall
    # Otherwise, print default message:
    mv a0, STDERR
    la a1, panic_msg
    li a2, panic_len
    li a7, SYS_WRITE
    ecall

    # --- Exit Program ---
    li a0, 1 # Exit code 1 (error)
    li a7, SYS_EXIT
    ecall
    # Should not reach here

# --- Other specific runtime error handlers (Need implementation) ---
# handle_out_of_bounds: Array index out of bounds.
# handle_null_dereference: Attempting to access memory via a null pointer (should be rare with ownership).
# ...

# --- Helper Routines (Need implementation) ---
# string_length_helper: Helper to get string length (from lib_string.s or utils_compiler.s)
# print_string_to_stderr_helper: Wrapper for writing a string to stderr
# ...