# tokens_def.asm
# ANT Compiler - Token Definitions
# Targets RISC-V
# Defines integer constants for token types and string literals for keywords.

.data
    # --- Token Type Constants ---
    # Assign unique integer values to each token type.
    # The lexer will output these integer values.
    .equ TOKEN_ERROR, -1          # Indicates a lexer error
    .equ TOKEN_EOF, 0             # End of File

    # Literals
    .equ TOKEN_IDENTIFIER, 1      # Variable or function name
    .equ TOKEN_INTEGER, 2         # Integer literal (e.g., 123)
    .equ TOKEN_FLOAT, 3           # Floating-point literal (e.g., 3.14)
    .equ TOKEN_STRING, 4          # String literal (e.g., "hello")
    .equ TOKEN_BOOLEAN, 5         # Boolean literal (true, false)

    # Keywords (Using values >= 100 to differentiate from basic literals)
    .equ TOKEN_KEYWORD_MATCH, 100 # 'match' keyword
    .equ TOKEN_KEYWORD_CASE, 101  # 'case' keyword
    .equ TOKEN_KEYWORD_IMPORT, 102 # 'import' keyword
    .equ TOKEN_KEYWORD_LET, 103   # 'let' (for variable declaration?)
    .equ TOKEN_KEYWORD_MUT, 104   # 'mut' (for mutability?)
    # ... add other ANT keywords (if, while, fn, struct, etc. if they exist) ...

    # Operators (Using values >= 200)
    .equ TOKEN_OP_ASSIGN, 200     # =
    .equ TOKEN_OP_PLUS, 201       # +
    .equ TOKEN_OP_MINUS, 202      # -
    .equ TOKEN_OP_STAR, 203       # *
    .equ TOKEN_OP_SLASH, 204      # /
    .equ TOKEN_OP_EQ, 205         # ==
    .equ TOKEN_OP_NE, 206         # !=
    .equ TOKEN_OP_LT, 207         # <
    .equ TOKEN_OP_LE, 208         # <=
    .equ TOKEN_OP_GT, 209         # >
    .equ TOKEN_OP_GE, 210         # >=
    .equ TOKEN_OP_AND, 211        # && (Logical AND)
    .equ TOKEN_OP_OR, 212         # || (Logical OR)
    .equ TOKEN_OP_ARROW, 213      # => (Used in match cases)
    # ... add other operators ...

    # Punctuation (Using values >= 300)
    .equ TOKEN_LPAREN, 300        # (
    .equ TOKEN_RPAREN, 301        # )
    .equ TOKEN_LBRACE, 302        # {
    .equ TOKEN_RBRACE, 303        # }
    .equ TOKEN_LBRACKET, 304      # [
    .equ TOKEN_RBRACKET, 305      # ]
    .equ TOKEN_COMMA, 306         # ,
    .equ TOKEN_SEMICOLON, 307     # ;
    .equ TOKEN_COLON, 308         # :
    .equ TOKEN_DOT, 309           # .
    .equ TOKEN_AMPERSAND, 310     # & (For borrowing/references?)
    # ... add other punctuation ...

    # --- Keyword String Literals ---
    # The lexer will compare potential identifiers against these strings.

    keyword_match_str:  .string "match"
    keyword_case_str:   .string "case"
    keyword_import_str: .string "import"
    keyword_let_str:    .string "let"
    keyword_mut_str:    .string "mut"
    # ... add other keyword strings ...

    # --- Keyword Lookup Table (Optional but helpful for Lexer) ---
    # A table mapping keyword strings to their token types.
    # Format: .word pointer_to_string, token_type_constant
    # Must be sorted or use hashing for efficient lookup in Assembly.
    # Example (simple, unsorted):
    # keyword_lookup_table:
    #   .word keyword_match_str, TOKEN_KEYWORD_MATCH
    #   .word keyword_case_str, TOKEN_KEYWORD_CASE
    #   .word keyword_import_str, TOKEN_KEYWORD_IMPORT
    #   .word 0, 0 # Sentinel to mark the end of the table

.text
    # No executable code in this file, only data definitions.