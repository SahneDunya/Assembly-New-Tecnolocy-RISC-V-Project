# datatypes_def.asm
# ANT Compiler - Data Type Definitions
# Targets RISC-V
# Defines properties of built-in data types at the Assembly level.

.data
    # --- Data Type IDs ---
    # Unique integer IDs for each type. Used in semantic analysis and symbol table.
    .equ TYPE_ERROR, 0            # Indicates a type error or unknown type
    .equ TYPE_INT, 1              # Integer type
    .equ TYPE_FLOAT, 2            # Floating-point type (assuming F extension)
    .equ TYPE_BOOL, 3             # Boolean type
    .equ TYPE_STRING_PTR, 4       # Pointer to string data
    .equ TYPE_VOID, 5             # Function return type for no value
    .equ TYPE_POINTER, 6          # Generic pointer type
    # ... add IDs for other types like structs, arrays, tuples, references ...

    # --- Data Type Properties (Size and Alignment) ---
    # Define the size (in bytes) and required memory alignment for each type.
    # This is architecture-dependent (RISC-V 64-bit assumed for pointer size).
    # .word format: Type ID, Size (bytes), Alignment (bytes)

    type_properties_table:
        # Type ID           Size (bytes)  Alignment (bytes)
        .word TYPE_INT,         8,            8             # RV64 int usually 64-bit (8 bytes), 8-byte aligned
        .word TYPE_FLOAT,       8,            8             # RV64 double-precision float (8 bytes), 8-byte aligned (if D extension)
                                                              # Use 4, 4 if using single-precision (F extension)
        .word TYPE_BOOL,        1,            1             # Boolean (1 byte)
        .word TYPE_STRING_PTR,  8,            8             # Pointer (8 bytes on RV64)
        .word TYPE_VOID,        0,            1             # Void has no size/alignment relevance
        .word TYPE_POINTER,     8,            8             # Generic pointer

        # --- Add properties for other types ---
        # For structs, size and alignment depend on member layout (compiler calculates)
        # But define a struct type ID: .equ TYPE_STRUCT_BASE, 100 # Start of struct IDs

        .word 0, 0, 0 # Sentinel

    # --- Structure Layouts (Conceptual) ---
    # If ANT has structs, you might define data here describing their member types and offsets.
    # This is complex and compiler-managed.
    # Example:
    # struct MyData { int count; bool enabled; };
    # mydata_struct_layout:
    #   .word TYPE_INT, 0         # count is an int at offset 0
    #   .word TYPE_BOOL, 8        # enabled is a bool at offset 8 (after padding if needed)
    #   .word 0, 0 # Sentinel for members
    #   .word mydata_struct_layout_size, mydata_struct_layout_alignment # Total size and alignment

.text
    # No executable code in this file, only data definitions.