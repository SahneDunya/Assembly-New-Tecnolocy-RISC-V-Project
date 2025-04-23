# semantic.asm
# ANT Compiler - Semantic Definitions / Data
# Targets RISC-V
# Contains data structures or tables used by the semantic analyzer (defined in semantic_analysis.asm).

.data
    # --- Type Compatibility Matrix (Example) ---
    # Defines which operations are valid for which type combinations.
    # This is a simplified concept. Real type systems are more complex.
    # Assumes integer IDs for data types are defined in datatypes_def.asm.
    # Format: .word op_token_type, left_type_id, right_type_id, result_type_id (0 if invalid)
    # -1 can be used as a wildcard for types.

    # Example data type IDs (assuming from datatypes_def.asm)
    # .equ TYPE_INT, 1
    # .equ TYPE_FLOAT, 2
    # .equ TYPE_BOOL, 3
    # .equ TYPE_STRING_PTR, 4
    # .equ TYPE_ANY, -1 # Wildcard

    # Example Operator IDs (assuming from tokens_def.asm)
    # .equ TOKEN_OP_PLUS, 201
    # .equ TOKEN_OP_EQ, 205
    # .equ TOKEN_OP_ASSIGN, 200

    type_compatibility_table:
        # Op Type           Left Type ID  Right Type ID   Result Type ID (0 = invalid)
        .word TOKEN_OP_PLUS,  TYPE_INT,      TYPE_INT,       TYPE_INT       # int + int -> int
        .word TOKEN_OP_PLUS,  TYPE_FLOAT,    TYPE_FLOAT,     TYPE_FLOAT     # float + float -> float
        .word TOKEN_OP_PLUS,  TYPE_INT,      TYPE_FLOAT,     TYPE_FLOAT     # int + float -> float (implicit coercion)
        .word TOKEN_OP_PLUS,  TYPE_FLOAT,    TYPE_INT,       TYPE_FLOAT     # float + int -> float (implicit coercion)
        .word TOKEN_OP_PLUS,  TYPE_STRING_PTR, TYPE_STRING_PTR, TYPE_STRING_PTR # string + string -> string (concatenation)

        .word TOKEN_OP_EQ,    TYPE_INT,      TYPE_INT,       TYPE_BOOL      # int == int -> bool
        .word TOKEN_OP_EQ,    TYPE_FLOAT,    TYPE_FLOAT,     TYPE_BOOL      # float == float -> bool
        .word TOKEN_OP_EQ,    TYPE_BOOL,     TYPE_BOOL,      TYPE_BOOL      # bool == bool -> bool
        .word TOKEN_OP_EQ,    TYPE_STRING_PTR, TYPE_STRING_PTR, TYPE_BOOL # string == string -> bool

        .word TOKEN_OP_ASSIGN, TYPE_ANY,     TYPE_ANY,       TYPE_ANY       # Assignment is complex, needs specific rules beyond this table
                                                                            # Usually checked based on mutability and ownership/borrowing

        .word 0, 0, 0, 0 # Sentinel to mark the end of the table

    # --- Implicit Coercion Rules (Example) ---
    # Defines when a type can be automatically converted to another.
    # Format: .word from_type_id, to_type_id
    # implicit_coercion_table:
    #   .word TYPE_INT, TYPE_FLOAT # int can be coerced to float
    #   .word 0, 0 # Sentinel

    # --- Data related to Scope and Lifetime (if managed via data tables) ---
    # ... definitions for scope types, lifetime boundaries etc. ...


.text
    # No executable code in this file, only data definitions.