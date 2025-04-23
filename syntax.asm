# syntax.asm
# ANT Compiler - Syntax Definitions / Data
# Targets RISC-V
# Contains data structures or tables used by the parser (defined in parser.asm).

.data
    # --- Operator Precedence Table (Example) ---
    # Defines the binding strength of operators. Used by the parser
    # when building the Abstract Syntax Tree (AST) for expressions.
    # Higher number usually means higher precedence.
    # Format: .word token_type, precedence_level, associativity (e.g., left=0, right=1)
    # Note: This is a very simplified example. Real tables are more complex.

    # Associativity constants (example)
    .equ ASSOC_LEFT, 0
    .equ ASSOC_RIGHT, 1
    .equ ASSOC_NONE, 2 # Non-associative (e.g., comparison operators)

    operator_precedence:
        # Token Type          Precedence  Associativity
        .word TOKEN_OP_STAR,      6,          ASSOC_LEFT      # *, / (Higher precedence)
        .word TOKEN_OP_SLASH,     6,          ASSOC_LEFT

        .word TOKEN_OP_PLUS,      5,          ASSOC_LEFT      # +, -
        .word TOKEN_OP_MINUS,     5,          ASSOC_LEFT

        .word TOKEN_OP_EQ,        4,          ASSOC_NONE      # ==, !=, <, <=, >, >= (Comparison)
        .word TOKEN_OP_NE,        4,          ASSOC_NONE
        .word TOKEN_OP_LT,        4,          ASSOC_NONE
        .word TOKEN_OP_LE,        4,          ASSOC_NONE
        .word TOKEN_OP_GT,        4,          ASSOC_NONE
        .word TOKEN_OP_GE,        4,          ASSOC_NONE

        .word TOKEN_OP_AND,       3,          ASSOC_LEFT      # && (Logical AND)

        .word TOKEN_OP_OR,        2,          ASSOC_LEFT      # || (Logical OR)

        .word TOKEN_OP_ASSIGN,    1,          ASSOC_RIGHT     # = (Lower precedence, right-associative)

        .word 0, 0, 0 # Sentinel to mark the end of the table

    # --- Other Potential Syntax Data ---
    # - Parsing tables for LALR or LR parsers (extremely complex in Assembly)
    # - Data defining expected token sequences for language constructs
    # - AST node type definitions (if not in a dedicated AST definition file)
    # .equ AST_NODE_TYPE_PROGRAM, 1
    # .equ AST_NODE_TYPE_MATCH_STMT, 10
    # .equ AST_NODE_TYPE_BINARY_OP, 20
    # ...

.text
    # No executable code in this file, only data definitions.