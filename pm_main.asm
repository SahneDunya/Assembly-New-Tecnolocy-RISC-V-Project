# pm_main.asm
# ANT Packet Manager - Main Entry Point
# Targets RISC-V (Linux ABI assumed for syscalls)

.global _start       # Make _start visible to the linker
.align 2             # Align to 4 bytes

.data
    # Data section for messages
    pm_usage_msg:   .string "Usage: antpm <command> [args...]\n"
                    .string "Commands: install, build, ...\n" # List commands
    pm_usage_len = . - pm_usage_msg

    pm_invalid_command_msg: .string "Error: Invalid command.\n"
    pm_invalid_command_len = . - pm_invalid_command_msg

.text

_start:
    # Entry point for the packet manager tool
    # a0 = argc (argument count)
    # a1 = argv (argument vector - array of strings)

    # Check for minimum number of arguments (at least program name + command)
    li t0, 2 # Minimum 2 arguments
    bge a0, t0, .L_enough_args # If argc >= 2, continue

    # Not enough arguments - print usage and exit
    li a7, 93           # syscall number for exit
    li a0, 1            # exit code 1 (error)
    addi sp, sp, -16    # Save ra, s0 (standard procedure even for quick exit)
    sd ra, 0(sp)
    sd s0, 8(sp) # s0 unused here, but saving is good practice

    li a7, 64           # syscall number for write
    li a0, 2            # file descriptor 2 (stderr)
    la a1, pm_usage_msg # address of message
    li a2, pm_usage_len # length of message
    ecall               # Print usage message

    # Exit with error code (already set)
    j .L_exit_pm # Jump to common exit

.L_enough_args:
    # Get the command string (argv[1])
    # argv is an array of pointers (each pointer is 8 bytes on 64-bit RISC-V)
    ld a0, 8(a1)        # a0 = pointer to argv[1] (the command string)

    # Prepare arguments for pm_handle_command:
    # a0: command string pointer (already set)
    # a1: argv pointer (array of all args)
    # a2: argc (total argument count)
    mv a1, a1           # Pass argv pointer
    mv a2, a0           # Pass argc (from entry)

    # Save ra and s0 before calling pm_handle_command
    addi sp, sp, -16
    sd ra, 0(sp)
    sd s0, 8(sp)

    # Call the command handler
    jal pm_handle_command

    # pm_handle_command returns exit code in a0
    mv s0, a0 # Save exit code

    # Restore ra, s0
    ld ra, 0(sp)
    ld s0, 8(sp)
    addi sp, sp, 16

    # Exit with the status returned by the command handler
    mv a0, s0 # a0 = exit code from handler
    li a7, 93 # syscall number for exit
    j .L_exit_pm # Jump to common exit

.L_invalid_command:
    # Restore stack (if needed)
    addi sp, sp, -16 # Save ra, s0
    sd ra, 0(sp)
    sd s0, 8(sp)

    # Print invalid command message
    li a7, 64           # syscall number for write
    li a0, 2            # file descriptor 2 (stderr)
    la a1, pm_invalid_command_msg # address of message
    li a2, pm_invalid_command_len # length of message
    ecall

    li a0, 1 # Exit with error code 1

.L_exit_pm:
    # Common exit point
    # a0 holds the final exit code
    ecall # Perform the exit system call