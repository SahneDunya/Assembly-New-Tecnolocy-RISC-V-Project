# variable_allocation.asm
# ANT Compiler - Variable Allocation Module
# Targets RISC-V
# Contains logic for assigning memory/register locations to variables.

.global allocate_global_variables
.global allocate_function_locals   # Called for each function
.global get_variable_location      # Called by code generator

.text

# allocate_global_variables: Assigns addresses in the .data section to global variables.
# Arguments: None (works on global scope symbols in the symbol table)
# Returns: None (updates symbol table)
allocate_global_variables:
    # Function prologue
    addi sp, sp, -8 # Save ra
    sd ra, 0(sp)

    # --- Logic for Global Allocation (Simplified) ---
    # 1. Get the global scope from the symbol table (Symbol Table must be initialized).
    #    la t0, global_scope # Assuming global_scope is a known label

    # 2. Traverse the symbols in the global scope's symbol table.
    #    # Need a function to iterate global symbols: `symbol_table_get_first_global`, `symbol_table_get_next_global`
    #    # mv a0, t0 # Pass global scope ptr
    #    # jal symbol_table_get_first_global # Hypothetical

    # 3. For each global variable symbol:
    #    a. Get the variable's type properties (size, alignment) from `datatypes_def.s` based on its type ID.
    #       # ld t1, symbol_type_id_offset(current_symbol_entry)
    #       # mv a0, t1; jal get_type_properties # Hypothetical helper
    #       # mv t2, a0 # t2 = size
    #       # mv t3, a1 # t3 = alignment (returned by helper)
    #    b. Determine the next available address in the .data section, respecting alignment.
    #       # Need a global pointer or counter for the current address in .data.
    #       # la t4, current_data_address_ptr
    #       # ld t5, 0(t4) # t5 = current data address
    #       # # Calculate aligned address: Need helper for alignment logic
    #       # # mv a0, t5; mv a1, t3; jal align_address # Hypothetical
    #       # # mv t5, a0 # t5 = aligned address
    #    c. Store the assigned global address in the symbol table entry for the variable.
    #       # sd t5, symbol_location_offset(current_symbol_entry) # Store location (address)
    #    d. Update the current .data address pointer by adding the variable's size.
    #       # add t5, t5, t2 # Add size
    #       # sd t5, 0(t4) # Save updated current address

    # 4. After traversing all global variables, the .data section layout is determined.

    # For this skeleton, just return.
    # Function epilogue
    ld ra, 0(sp)
    addi sp, sp, 8
    jr ra


# allocate_function_locals: Assigns stack offsets to local variables and parameters for a function.
# Called after parsing/semantic analysis of a function body.
# Arguments:
# a0: Pointer to the function's AST node or symbol table entry.
# a1: Pointer to the function's scope structure.
# Returns:
# a0: Total stack frame size needed for locals and saved registers for this function.
allocate_function_locals:
    # Function prologue
    addi sp, sp, -16 # Save ra, s0
    sd ra, 0(sp)
    sd s0, 8(sp)
    mv s0, a0 # s0 = function node/symbol ptr
    mv s1, a1 # s1 = function scope ptr

    # --- Logic for Local Allocation (Simplified) ---
    # 1. Initialize stack offset counter (usually starts after saved registers + return address).
    #    li t0, 16 # Example: Start after saving ra (8) and s0 (8)

    # 2. Traverse the parameters of the function (from function node or symbol table).
    #    For each parameter:
    #    a. Get parameter's type properties (size, alignment).
    #    b. Assign a location:
    #       - If first few parameters, assign to argument registers (a0-a7). Need to track which are used.
    #       - If more parameters than registers, they are passed on the caller's stack frame. Access requires calculating offset relative to FP or SP upon entry.
    #    c. Store the assigned location (register ID or stack access info) in the parameter's symbol table entry.

    # 3. Traverse the local variables declared within the function's scope (s1).
    #    For each local variable symbol:
    #    a. Get the variable's type properties (size, alignment).
    #    b. Allocate space on the stack. Need to decrement stack offset counter, respecting alignment.
    #       # Use stack offset counter t0.
    #       # mv a0, t0; mv a1, alignment; jal align_stack_offset_down # Hypothetical helper
    #       # mv t0, a0 # t0 = aligned offset
    #       # sub t0, t0, size # Decrement offset by size
    #    c. Store the assigned stack offset (relative to FP or SP) in the variable's symbol table entry.
    #       # sd t0, symbol_location_offset(current_local_symbol) # Store location (offset)

    # 4. After traversing all locals, t0 holds the total size needed for locals relative to the initial stack frame point.
    #    This size must be added to the frame pointer adjustment in the function prologue/epilogue.

    # 5. Determine total stack frame size needed (locals + saved registers + return address + potential stack args for calls made *by* this function).
    #    mv a0, t0 # a0 = size for locals (for this skeleton)
    #    # Add size for saved registers (e.g., 16 for ra+s0)
    #    # addi a0, a0, 16
    #    # Ensure total frame size is aligned (e.g., 16-byte aligned on RV64 for performance/ABI compliance)
    #    # mv a1, 16; jal align_up # Hypothetical alignment helper
    #    # mv a0, a0 # a0 = final aligned frame size

    # For this skeleton, return a dummy size.
    li a0, 32 # Example: Return a size of 32 bytes

    # Function epilogue
    ld ra, 0(sp)
    ld s0, 8(sp)
    addi sp, sp, 16
    jr ra            # Return (stack frame size in a0)

# get_variable_location: Looks up a variable's location (register, stack offset, or address).
# Called by the code generator when it needs to access a variable.
# Arguments:
# a0: Pointer to the variable's symbol table entry.
# Returns:
# a0: Location type (e.g., LOCATION_TYPE_REGISTER, LOCATION_TYPE_STACK, LOCATION_TYPE_GLOBAL).
# a1: The actual location value (e.g., register ID, stack offset, or global address).
# a2: Pointer to type properties for the variable (size, alignment).
get_variable_location:
    # Function prologue
    addi sp, sp, -16 # Save ra, s0
    sd ra, 0(sp)
    sd s0, 8(sp)
    mv s0, a0 # s0 = symbol entry pointer

    # --- Get Location Logic (Simplified) ---
    # 1. Load the stored location value from the symbol table entry.
    #    ld t0, symbol_location_offset(s0) # t0 holds the location value

    # 2. Determine the location type. This could be stored directly in the symbol entry,
    #    or inferred from the value itself (e.g., small number could be register ID,
    #    negative number could be stack offset, large number could be global address).
    #    # ld a0, symbol_location_type_offset(s0) # Assuming type is stored
    #    # or...
    #    # Check value range/sign to infer type

    # 3. Load the variable's type properties.
    #    ld t1, symbol_type_id_offset(s0) # Get type ID
    #    mv a0, t1; jal get_type_properties # Hypothetical helper
    #    mv a2, a0 # a2 = pointer to type properties

    # 4. Return the location type (a0), location value (a1), and type properties pointer (a2).
    #    mv a1, t0 # a1 = location value

    # For this skeleton, return dummy values (e.g., Stack location type, offset 0, dummy type props)
    li a0, LOCATION_TYPE_STACK # Example location type constant
    li a1, 0                   # Example stack offset
    la a2, dummy_type_properties # Example pointer to type properties data

    # Function epilogue
    ld ra, 0(sp)
    ld s0, 8(sp)
    addi sp, sp, 16
    jr ra            # Return (results in a0, a1, a2)

# --- Helper Routines (Need implementation) ---
# get_type_properties: Looks up type size/alignment from datatypes_def.s table.
# align_address: Aligns an address up to a boundary.
# align_stack_offset_down: Aligns a stack offset downwards.
# symbol_table_get_first_global, symbol_table_get_next_global: Iterate global symbols.
# ... logic for tracking register usage (if implementing register allocation) ...

.data
# Example location type constants
.equ LOCATION_TYPE_UNKNOWN, 0
.equ LOCATION_TYPE_REGISTER, 1
.equ LOCATION_TYPE_STACK, 2
.equ LOCATION_TYPE_GLOBAL, 3
# ... add others like LOCATION_TYPE_PARAMETER_REG, LOCATION_TYPE_PARAMETER_STACK ...

# Dummy type properties data for skeleton return
dummy_type_properties:
    .word TYPE_INT, 8, 8 # Example: Represents int (ID 1, size 8, align 8)

# Pointer to track the current address in the .data section for global allocation
current_data_address_ptr: .word 0 # Will be initialized to start of .data by linker or startup code

# Need memory space allocated for the .data section itself, handled by linker script usually.
# Example: .section .data,"aw",@progbits