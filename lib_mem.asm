# lib_mem.asm
# ANT Standard Library - Memory Module
# Targets RISC-V

.global ant_memcpy
.global ant_memset

.text

# ant_memcpy: Copies 'size' bytes from source to destination.
# Arguments:
# a0: Destination pointer.
# a1: Source pointer.
# a2: Size in bytes.
# Returns:
# a0: Destination pointer (conventionally).
ant_memcpy:
    # Function prologue
    addi sp, sp, -16 # Save ra, s0
    sd ra, 0(sp)
    sd s0, 8(sp)
    mv s0, a0 # s0 = dest

    # --- Memcpy Logic ---
    # Use t0-t2 as temporary registers
    mv t0, a0 # t0 = current dest pointer
    mv t1, a1 # t1 = current src pointer
    mv t2, a2 # t2 = size counter

    memcpy_loop:
        beq t2, zero, memcpy_end # If size is 0, finished

        # Copy one byte
        lb t3, 0(t1) # Load byte from source
        sb t3, 0(t0) # Store byte to destination

        # Move pointers and decrement size
        addi t0, t0, 1
        addi t1, t1, 1
        addi t2, t2, -1

        j memcpy_loop # Continue loop

    memcpy_end:
    mv a0, s0 # Return original destination pointer

    # Function epilogue
    ld ra, 0(sp)
    ld s0, 8(sp)
    addi sp, sp, 16
    jr ra

# ant_memset: Fills 'size' bytes of memory starting at 'dest' with 'value'.
# Arguments:
# a0: Destination pointer.
# a1: Value (byte) to set.
# a2: Size in bytes.
# Returns:
# a0: Destination pointer (conventionally).
ant_memset:
    # Function prologue
    addi sp, sp, -16 # Save ra, s0
    sd ra, 0(sp)
    sd s0, 8(sp)
    mv s0, a0 # s0 = dest

    # --- Memset Logic ---
    # Use t0-t2 as temporary registers
    mv t0, a0 # t0 = current dest pointer
    andi t1, a1, 0xFF # t1 = value (ensure it's a byte)
    mv t2, a2 # t2 = size counter

    memset_loop:
        beq t2, zero, memset_end # If size is 0, finished

        # Set one byte
        sb t1, 0(t0) # Store value to destination

        # Move pointer and decrement size
        addi t0, t0, 1
        addi t2, t2, -1

        j memset_loop # Continue loop

    memset_end:
    mv a0, s0 # Return original destination pointer

    # Function epilogue
    ld ra, 0(sp)
    ld s0, 8(sp)
    addi sp, sp, 16
    jr ra

# --- Other potential memory functions (Need implementation) ---
# ant_memcmp: Compares two memory blocks.
# ant_memmove: Copies memory (handles overlapping regions).
# ... interactions with allocator if allocation/deallocation is exposed ...