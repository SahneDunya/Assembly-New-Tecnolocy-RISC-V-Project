# compiler_main.asm
# ANT Compiler - Main Entry Point
# Targets RISC-V (Linux ABI assumed for syscalls)

.global _start       # Make _start visible to the linker
.align 2             # Align to 4 bytes

.data
    # Data section for messages and strings

    arg_error_msg:   .string "Usage: antc <input_file.ant>\n"
    arg_error_len = . - arg_error_msg

    file_open_error_msg: .string "Error: Could not open file "
    # Need to append filename here for a real error message
    file_open_error_len = . - file_open_error_msg

    # Buffer for reading input file content (simplified)
    # Real compiler might read chunk by chunk or memory map
    input_buffer_size = 4096
    input_buffer:    .byte 0:input_buffer_size # Allocate buffer filled with zeros

.text

_start:
    # Entry point for the program
    # a0 = argc (argument count)
    # a1 = argv (argument vector - array of strings)

    # Check number of arguments (expecting 2: program name + input file)
    li a7, 93           # syscall number for exit
    li a0, 1            # exit code 1 (error)
    addi sp, sp, -16    # Save return address and s0 on stack
    sd ra, 0(sp)
    sd s0, 8(sp)

    addi t0, a0, -2     # argc - 2
    bne t0, zero, handle_arg_error # If argc != 2, jump to error handler

    # Get input filename (argv[1])
    # argv is an array of pointers (each pointer is 8 bytes on 64-bit RISC-V)
    ld s0, 8(a1)        # Load the pointer to the second argument (argv[1]) into s0

    # --- File Handling (Simplified) ---
    # This is a placeholder. A real compiler would open, read the file content
    # and pass it to the lexer, or pass a file descriptor.
    # Let's assume for this skeleton that the file content is loaded into input_buffer
    # (This part is NOT implemented here - just conceptual)

    # Example: Calling a hypothetical file reading routine
    # li a0, s0         # Pass filename pointer
    # li a1, input_buffer # Pass buffer pointer
    # li a2, input_buffer_size # Pass buffer size
    # jal read_file_to_buffer # Call a routine to read the file (needs implementation)

    # For this example, let's just pass the filename string pointer to the lexer/parser
    # as if the file content is magically available via s0 (the filename)
    # In reality, you'd open the file, read its content, and pass the buffer/size.

    # --- Call Lexer ---
    # The lexer needs the source code. Let's assume s0 (filename pointer)
    # is enough for the lexer to figure out what to do (e.g., open and read).
    mv a0, s0           # Pass the input filename pointer to lexer_init

    # Save s0 before calling lexer_init if needed by compiler_main later
    # sd s0, 8(sp) # s0 already saved above

    jal lexer_init      # Call the lexer initialization

    # Lexer_init might return a pointer to the token stream or state in a0
    mv s0, a0           # Save the lexer state/token stream pointer in s0

    # Check for lexer initialization errors (e.g., file not found/readable)
    # if a0 is 0 or an error code
    # bne a0, zero, handle_lexer_error # Needs implementation

    # --- Call Parser ---
    # The parser needs the token stream/lexer state. Pass the result from lexer_init
    mv a0, s0           # Pass the lexer state/token stream pointer to parse

    jal parse           # Call the parser

    # Parser might return a pointer to the root of the AST in a0
    mv s0, a0           # Save the AST root pointer in s0

    # Check for parser errors (e.g., syntax error)
    # if a0 is 0 or an error code indicating error vs success
    # bne a0, zero, handle_parser_error # Needs implementation

    # --- Call Semantic Analysis, Code Generation, etc. ---
    # ... (Add calls to other compiler stages here, passing the AST root)
    # mv a0, s0           # Pass AST root to semantic_analysis
    # jal semantic_analysis
    # ...

    # --- Compilation Successful ---
    # Exit with success code
    li a7, 93           # syscall number for exit
    li a0, 0            # exit code 0 (success)
    ecall               # Perform the system call

handle_arg_error:
    # Restore stack
    ld ra, 0(sp)
    ld s0, 8(sp)
    addi sp, sp, 16

    # Print usage message
    li a7, 64           # syscall number for write
    li a0, 2            # file descriptor 2 (stderr)
    la a1, arg_error_msg # address of message
    li a2, arg_error_len # length of message
    ecall               # Perform the system call

    # Exit with error code (already set in _start before branching)
    ecall

# --- Error Handling Placeholders (Need implementation) ---
# handle_lexer_error:
    # Print lexer error message
    # Exit with error code
    # ...

# handle_parser_error:
    # Print parser error message
    # Exit with error code
    # ...

# --- Helper Routines (Need implementation) ---
# read_file_to_buffer:
    # Takes filename (a0), buffer (a1), buffer_size (a2)
    # Uses open, read, close syscalls
    # Returns status/bytes read in a0
    # ...