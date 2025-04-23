# syscalls.asm
# ANT Standard Library - Syscall Wrappers
# Targets RISC-V (Linux ABI assumed)
# Provides helper functions/macros for common system calls.

# --- Syscall Numbers (Linux ABI) ---
.equ SYS_EXIT, 93
.equ SYS_WRITE, 64
.equ SYS_READ, 63
.equ SYS_OPEN, 1024
.equ SYS_CLOSE, 57
.equ SYS_MKDIR, 34
.equ SYS_STAT, 179
# ... add other necessary syscall numbers ...

# --- Syscall Wrapper Functions (Alternative: Use Macros for inline syscalls) ---
# Using functions adds call overhead but can simplify code if syscalls are complex.
# Using macros expands inline, no call overhead. Macros are often preferred for syscalls.

# Example using functions:

# sys_exit: Wrapper for exit syscall.
# Arguments: a0 = exit_code
# Returns: Does not return.
.global sys_exit
sys_exit:
    # No prologue/epilogue as it doesn't return
    # a0 already has the exit_code
    li a7, SYS_EXIT
    ecall
    # Should not reach here

# sys_write: Wrapper for write syscall.
# Arguments: a0 = fd, a1 = buf_ptr, a2 = count
# Returns: a0 = bytes written or negative error code
.global sys_write
sys_write:
    # Function prologue (Save any s registers used by wrapper - none here)
    addi sp, sp, -8
    sd ra, 0(sp)

    # Arguments are already in a0, a1, a2
    li a7, SYS_WRITE
    ecall

    # Result is in a0

    # Function epilogue
    ld ra, 0(sp)
    addi sp, sp, 8
    jr ra

# sys_read: Wrapper for read syscall.
# Arguments: a0 = fd, a1 = buf_ptr, a2 = count
# Returns: a0 = bytes read (0 for EOF, negative error code)
.global sys_read
sys_read:
    # Function prologue
    addi sp, sp, -8
    sd ra, 0(sp)

    # Arguments are already in a0, a1, a2
    li a7, SYS_READ
    ecall

    # Result is in a0

    # Function epilogue
    ld ra, 0(sp)
    addi sp, sp, 8
    jr ra

# --- Example using Macros (Often more direct) ---
# .macro syscall_exit status
#     li a0, \status
#     li a7, SYS_EXIT
#     ecall
# .endm
#
# .macro syscall_write fd, buf, count
#     li a0, \fd
#     li a1, \buf
#     li a2, \count
#     li a7, SYS_WRITE
#     ecall
# .endm

# Usage in other Assembly files:
# Instead of `li a7, 93; ecall`, use `jal sys_exit` or `syscall_exit 0`.
# Instead of `li a0, 1; la a1, msg; li a2, len; li a7, 64; ecall`, use `jal sys_write` or `syscall_write 1, msg, len`.

# --- Add wrappers/macros for other syscalls (open, close, mkdir, stat, etc.) ---