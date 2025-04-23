# symbol_table.asm
# ANT Compiler - Symbol Table Module
# Targets RISC-V

.global symbol_table_init
.global symbol_table_enter_scope
.global symbol_table_exit_scope
.global symbol_table_add_symbol
.global symbol_table_lookup_symbol

.data
    # Data section for Symbol Table structures

    # Define structure for a Symbol Table Entry (conceptual)
    # An entry needs to store:
    # - Pointer to symbol name (string)
    # - Symbol type (integer ID)
    # - Symbol location (e.g., stack offset, global address, register ID)
    # - Mutability flag
    # - Ownership/Borrowing state info (pointer to state or flags)
    # - Pointer to the next entry in case of hash collision or linked list
    .equ SYMBOL_ENTRY_SIZE, 32 # Example size in bytes (adjust based on actual fields)
    .equ SYMBOL_ENTRY_NAME_PTR_OFFSET, 0
    .equ SYMBOL_ENTRY_TYPE_OFFSET, 8
    .equ SYMBOL_ENTRY_LOC_OFFSET, 12 # Adjust based on pointer size (4 or 8 bytes)
    .equ SYMBOL_ENTRY_MUTABLE_OFFSET, 20
    .equ SYMBOL_ENTRY_OWNERSHIP_OFFSET, 24 # Pointer or flags
    .equ SYMBOL_ENTRY_NEXT_OFFSET, 28 # Pointer to next entry

    # Define structure for a Scope (conceptual)
    # A scope needs:
    # - Pointer to its own symbol entry table (e.g., a hash table array or linked list head)
    # - Pointer to the parent scope
    # - Scope ID or type (global, function, block)
    .equ SCOPE_SIZE, 24 # Example size in bytes
    .equ SCOPE_TABLE_PTR_OFFSET, 0
    .equ SCOPE_PARENT_PTR_OFFSET, 8
    .equ SCOPE_ID_OFFSET, 16

    # Global Scope (initial scope)
    global_scope: .byte 0:SCOPE_SIZE # Allocate memory for the global scope

    # Keep track of the current active scope (pointer)
    current_scope_ptr: .word 0 # Will point to global_scope initially

    # A stack for scope pointers (if managing scopes on a stack)
    # scope_stack: .word 0:64 # Example stack of 64 scope pointers
    # scope_stack_top: .word 0 # Pointer to the current top of the scope stack

.text

# symbol_table_init: Initializes the global symbol table and sets the current scope.
# Arguments: None
# Returns: None
symbol_table_init:
    # Function prologue
    addi sp, sp, -8 # Adjust stack pointer
    sd ra, 0(sp)     # Save return address

    # --- Initialization Logic (Simplified) ---
    # 1. Initialize the global_scope structure (e.g., set table pointer to null, parent to null, ID).
    #    la t0, global_scope
    #    sd zero, SCOPE_TABLE_PTR_OFFSET(t0)
    #    sd zero, SCOPE_PARENT_PTR_OFFSET(t0)
    #    li t1, SCOPE_GLOBAL # Assume SCOPE_GLOBAL is a constant
    #    sd t1, SCOPE_ID_OFFSET(t0)

    # 2. Set current_scope_ptr to point to global_scope.
    #    la t0, global_scope
    #    la t1, current_scope_ptr
    #    sd t0, 0(t1)

    # 3. Initialize the scope stack if using a stack-based scope management.
    #    la t0, scope_stack_top
    #    la t1, scope_stack
    #    sd t1, 0(t0) # Stack top points to the beginning

    # 4. Push the global scope onto the scope stack.
    #    la t0, global_scope
    #    mv a0, t0 # Arg 0: pointer to global scope
    #    jal symbol_table_enter_scope # Use the enter_scope routine

    # For this skeleton, just return
    # Function epilogue
    ld ra, 0(sp)     # Restore return address
    addi sp, sp, 8   # Restore stack pointer
    jr ra            # Return

# symbol_table_enter_scope: Creates and enters a new scope.
# Arguments:
# a0: Scope ID or type (e.g., SCOPE_FUNCTION, SCOPE_BLOCK).
# Returns:
# a0: Pointer to the newly created scope structure.
symbol_table_enter_scope:
    # Function prologue
    addi sp, sp, -16 # Save ra, s0
    sd ra, 0(sp)
    sd s0, 8(sp)

    # --- Logic to Enter Scope ---
    # 1. Allocate memory for the new scope structure (Needs memory allocation).
    #    li a0, SCOPE_SIZE
    #    jal mem_alloc # Hypothetical allocation
    #    mv s0, a0 # s0 holds the new scope pointer

    # 2. Get the current scope pointer.
    #    la t0, current_scope_ptr
    #    ld t1, 0(t0) # t1 holds current scope pointer

    # 3. Initialize the new scope:
    #    - Set its parent pointer to the current scope (t1).
    #    - Set its symbol table pointer (initially empty/null).
    #    - Set its ID based on a0 (argument).
    #    sd t1, SCOPE_PARENT_PTR_OFFSET(s0)
    #    sd zero, SCOPE_TABLE_PTR_OFFSET(s0)
    #    sd a0, SCOPE_ID_OFFSET(s0)

    # 4. Update current_scope_ptr to point to the new scope.
    #    la t0, current_scope_ptr
    #    sd s0, 0(t0)

    # 5. (If using scope stack) Push the new scope pointer onto the scope stack.
    #    la t0, scope_stack_top
    #    ld t1, 0(t0) # Get current stack top address
    #    sd s0, 0(t1) # Store new scope pointer at top
    #    addi t1, t1, 8 # Move stack top pointer (assuming 8-byte pointers)
    #    sd t1, 0(t0) # Update scope_stack_top

    # Return the new scope pointer
    mv a0, s0

    # Function epilogue
    ld ra, 0(sp)
    ld s0, 8(sp)
    addi sp, sp, 16
    jr ra

# symbol_table_exit_scope: Exits the current scope and returns to the parent.
# Arguments: None
# Returns: None
symbol_table_exit_scope:
    # Function prologue
    addi sp, sp, -16 # Save ra, s0
    sd ra, 0(sp)
    sd s0, 8(sp)

    # --- Logic to Exit Scope ---
    # 1. Get the current scope pointer.
    #    la t0, current_scope_ptr
    #    ld s0, 0(t0) # s0 holds current scope pointer

    # 2. Get the parent scope pointer from the current scope structure.
    #    ld t1, SCOPE_PARENT_PTR_OFFSET(s0) # t1 holds parent scope pointer

    # 3. Update current_scope_ptr to point to the parent scope (t1).
    #    sd t1, 0(t0)

    # 4. (If using scope stack) Pop from the scope stack.
    #    la t0, scope_stack_top
    #    ld t1, 0(t0) # Get current stack top address
    #    addi t1, t1, -8 # Move stack top pointer down
    #    sd t1, 0(t0) # Update scope_stack_top
    #    # Optional: Clear the popped entry: sd zero, 0(t1)

    # 5. Optional: Free the memory for the exited scope structure (Needs memory management).
    #    mv a0, s0 # Pass pointer to scope to free
    #    jal mem_free # Hypothetical call

    # For this skeleton, just return
    # Function epilogue
    ld ra, 0(sp)
    ld s0, 8(sp)
    addi sp, sp, 16
    jr ra

# symbol_table_add_symbol: Adds a new symbol entry to the current scope.
# Arguments:
# a0: Pointer to symbol name string.
# a1: Symbol type (integer ID).
# a2: Symbol location (e.g., stack offset).
# a3: Mutability flag.
# a4: Ownership/Borrowing state info pointer.
# Returns:
# a0: 0 on error (e.g., symbol already exists in scope), non-zero on success.
symbol_table_add_symbol:
    # Function prologue
    addi sp, sp, -40 # Save ra, s0-s4
    sd ra, 0(sp)
    sd s0, 8(sp)
    sd s1, 16(sp)
    sd s2, 24(sp)
    sd s3, 32(sp)
    mv s0, a0 # s0 = name ptr
    mv s1, a1 # s1 = type
    mv s2, a2 # s2 = location
    mv s3, a3 # s3 = mutable
    mv s4, a4 # s4 = ownership state ptr

    # --- Logic to Add Symbol ---
    # 1. Get the current scope pointer.
    #    la t0, current_scope_ptr
    #    ld t1, 0(t0) # t1 holds current scope pointer

    # 2. Check if a symbol with the same name already exists in the current scope.
    #    This requires traversing the current scope's symbol table (hash table or linked list)
    #    and comparing names using a string comparison routine (from utils_compiler.s).
    #    If exists, report error and return 0.
    #    # Example: Check for duplicate (very simplified)
    #    # mv a0, s0 # name ptr
    #    # mv a1, t1 # current scope ptr
    #    # jal lookup_symbol_in_scope # Hypothetical function to search only in current scope
    #    # bne a0, zero, handle_duplicate_symbol # If non-zero, found a duplicate

    # 3. Allocate memory for a new symbol entry (Needs memory allocation).
    #    li a0, SYMBOL_ENTRY_SIZE
    #    jal mem_alloc # Hypothetical allocation
    #    mv t2, a0 # t2 holds the new symbol entry pointer

    # 4. Populate the new symbol entry structure using the arguments (s0, s1, s2, s3, s4).
    #    sd s0, SYMBOL_ENTRY_NAME_PTR_OFFSET(t2) # Store name pointer
    #    sw s1, SYMBOL_ENTRY_TYPE_OFFSET(t2)   # Store type (assuming 4-byte int)
    #    sd s2, SYMBOL_ENTRY_LOC_OFFSET(t2)   # Store location
    #    sb s3, SYMBOL_ENTRY_MUTABLE_OFFSET(t2) # Store mutable (assuming 1-byte bool)
    #    sd s4, SYMBOL_ENTRY_OWNERSHIP_OFFSET(t2) # Store ownership state ptr
    #    sd zero, SYMBOL_ENTRY_NEXT_OFFSET(t2) # Initialize next pointer to null

    # 5. Add the new entry to the current scope's symbol table data structure.
    #    If using a hash table: calculate hash, find bucket, add to linked list in bucket.
    #    If using a simple linked list for the scope: add to the head or tail.
    #    # Example (Add to head of a linked list stored in the scope structure):
    #    # ld t3, SCOPE_TABLE_PTR_OFFSET(t1) # Get current list head from scope
    #    # sd t3, SYMBOL_ENTRY_NEXT_OFFSET(t2) # New entry points to old head
    #    # sd t2, SCOPE_TABLE_PTR_OFFSET(t1) # Scope's head now points to new entry

    # Return success
    li a0, 1

    # Function epilogue
    ld ra, 0(sp)
    ld s0, 8(sp)
    ld s1, 16(sp)
    ld s2, 24(sp)
    ld s3, 32(sp)
    addi sp, sp, 40
    jr ra

# symbol_table_lookup_symbol: Searches for a symbol in the current and parent scopes.
# Arguments:
# a0: Pointer to symbol name string.
# Returns:
# a0: Pointer to the Symbol Table Entry if found, 0 otherwise.
symbol_table_lookup_symbol:
    # Function prologue
    addi sp, sp, -16 # Save ra, s0
    sd ra, 0(sp)
    sd s0, 8(sp)
    mv s0, a0 # s0 = name ptr to search

    # --- Logic to Lookup Symbol ---
    # 1. Start search from the current scope.
    #    la t0, current_scope_ptr
    #    ld t1, 0(t0) # t1 holds the current scope pointer

    # 2. Loop through scopes until global scope or symbol is found.
    #    lookup_loop:
    #    beq t1, zero, symbol_not_found # If scope pointer is null, symbol not found

    #    # Search for the symbol within the current scope (t1)
    #    # This involves traversing the current scope's symbol entry data structure.
    #    # Need a helper function: `search_symbol_in_scope`
    #    # mv a0, s0 # name ptr
    #    # mv a1, t1 # current scope ptr
    #    # jal search_symbol_in_scope # Hypothetical function
    #    # mv t2, a0 # t2 holds result: entry pointer or 0

    #    # Check if symbol was found in this scope
    #    # bne t2, zero, symbol_found # If non-zero, jump to found handler

    #    # If not found in current scope, move to parent scope
    #    # ld t1, SCOPE_PARENT_PTR_OFFSET(t1)
    #    # j lookup_loop # Continue loop with parent scope

    #    search_symbol_in_scope: # Hypothetical helper function
    #    # Arguments: a0 = name ptr, a1 = scope ptr
    #    # Returns: a0 = entry ptr or 0
    #    # ... implementation to search hash table/linked list in scope (a1), comparing names (a0) ...
    #    # jr ra # Return from helper

    # --- If Symbol Found ---
    # symbol_found:
    #    mv a0, t2 # Return the found entry pointer (t2)
    #    j lookup_epilogue # Jump to common epilogue

    # --- If Symbol Not Found ---
    symbol_not_found:
    li a0, 0 # Return 0 to indicate not found

    # Common epilogue
    lookup_epilogue:
    # Function epilogue
    ld ra, 0(sp)
    ld s0, 8(sp)
    addi sp, sp, 16
    jr ra

# --- Helper Routines (Need implementation) ---
# hash_string: Calculates hash for a symbol name.
# lookup_symbol_in_scope: Searches for a symbol within a single specified scope.
# ... other data structure management helpers ...