# lib_data_structures.asm
# ANT Standard Library - Data Structures Module
# Targets RISC-V

.global ant_array_get    # Get element from an array (returns value or pointer)

.text

# ant_array_get: Gets an element from an array by index.
# Assumes array is contiguous memory, elements are of uniform size.
# Arguments:
# a0: Pointer to the start of the array.
# a1: Index (integer).
# a2: Size of each element in bytes (integer).
# Returns:
# a0: Pointer to the element at the given index. (Or the value itself, depending on convention)
ant_array_get:
    # Function prologue
    addi sp, sp, -8 # Save ra
    sd ra, 0(sp)

    # --- Array Get Logic ---
    # Calculate offset = index * element_size
    mul t0, a1, a2 # t0 = index * element_size

    # Calculate element address = array_start_ptr + offset
    add a0, a0, t0 # a0 = array_start_ptr + offset (a0 now points to the element)

    # Return the pointer to the element (a0)
    # If the convention was to return the value itself, you'd add a load instruction here:
    # Example (loading an 8-byte value): ld a0, 0(a0)

    # Function epilogue
    ld ra, 0(sp)
    addi sp, sp, 8
    jr ra

# --- Other potential data structure functions (Need implementation) ---
# ant_array_set: Set element at index.
# ant_list_create: Create a new linked list.
# ant_list_add: Add element to a list.
# ant_list_remove: Remove element from a list.
# ... implementing full data structures (lists, maps, trees) in Assembly is very complex!