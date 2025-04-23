# lib_core.asm
# ANT Standard Library - Core Module
# Targets RISC-V (Linux ABI assumed for syscalls)

.global ant_exit       # Make ant_exit visible to the linker

.text

# ant_exit: Exits the ANT program with a given status code.
# Arguments:
# a0: Exit status code (integer).
# Returns: Does not return.
ant_exit:
    # No need for function prologue/epilogue as this function does not return
    # and we trust the caller's stack setup before this call.

    # Use the exit system call
    # syscall number for exit is 93 in RISC-V Linux ABI
    # a0 already contains the exit code from the function argument

    li a7, 93           # Load syscall number for exit
    ecall               # Perform the system call (program terminates)

# --- Other potential core functions (Need implementation) ---
# ant_panic: Handles unrecoverable runtime errors (e.g., prints error, calls ant_exit)
# ant_malloc: Basic memory allocation routine for runtime use (if needed by library or ownership model runtime support)
# ant_free: Basic memory deallocation routine
# ...