# lib_math.asm
# ANT Standard Library - Math Module
# Targets RISC-V (Integer operations)

.global ant_abs_int
.global ant_max_int
.global ant_min_int

.text

# ant_abs_int: Calculates the absolute value of an integer.
# Arguments:
# a0: Integer value.
# Returns:
# a0: Absolute value.
ant_abs_int:
    # Function prologue
    addi sp, sp, -8 # Save ra
    sd ra, 0(sp)

    # --- Abs Logic ---
    # Use t0 as temporary
    mv t0, a0 # Copy input
    bge t0, zero, is_positive # If input >= 0, it's positive

    # If negative, negate it
    neg a0, a0 # a0 = -a0

is_positive:
    # Return a0 (either original or negated value)

    # Function epilogue
    ld ra, 0(sp)
    addi sp, sp, 8
    jr ra

# ant_max_int: Returns the maximum of two integers.
# Arguments:
# a0: First integer.
# a1: Second integer.
# Returns:
# a0: The larger integer.
ant_max_int:
    # Function prologue
    addi sp, sp, -8 # Save ra
    sd ra, 0(sp)

    # --- Max Logic ---
    # Use t0 as temporary
    bge a0, a1, a0_is_max # If a0 >= a1, a0 is max

    # Otherwise, a1 is max
    mv a0, a1 # a0 = a1

a0_is_max:
    # a0 already holds the max value

    # Function epilogue
    ld ra, 0(sp)
    addi sp, sp, 8
    jr ra

# ant_min_int: Returns the minimum of two integers.
# Arguments:
# a0: First integer.
# a1: Second integer.
# Returns:
# a0: The smaller integer.
ant_min_int:
    # Function prologue
    addi sp, sp, -8 # Save ra
    sd ra, 0(sp)

    # --- Min Logic ---
    # Use t0 as temporary
    ble a0, a1, a0_is_min # If a0 <= a1, a0 is min

    # Otherwise, a1 is min
    mv a0, a1 # a0 = a1

a0_is_min:
    # a0 already holds the min value

    # Function epilogue
    ld ra, 0(sp)
    addi sp, sp, 8
    jr ra

# --- Other potential math functions (Need implementation) ---
# Integer: Multiplication, Division, Modulo (if not direct instructions)
# Floating-Point (if RISC-V F/D extensions are supported and used): ant_fadd, ant_fsub, ant_fmul, ant_fdiv, ant_fsqrt, sin, cos, tan, log, exp, etc. (Complex!)
# ...