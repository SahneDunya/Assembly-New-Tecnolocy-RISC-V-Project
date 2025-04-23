# match_translation.asm
# ANT Compiler - Match Statement Code Generation
# Targets RISC-V
# Translates ANT 'match' statements into RISC-V Assembly.

.global generate_match_code # Called by code_generator.asm

.text

# generate_match_code: Generates RISC-V Assembly code for an ANT 'match' statement.
# Arguments:
# a0: Pointer to the 'match' statement AST node.
# a1: Pointer to the current code generation state.
# Returns: None (emits code into the output buffer managed by code_generator.s)
generate_match_code:
    # Function prologue
    addi sp, sp, -16 # Save ra, s0
    sd ra, 0(sp)
    sd s0, 8(sp)
    mv s0, a0 # s0 = match AST node ptr
    mv s1, a1 # s1 = code generation state ptr

    # --- Match Translation Logic (Simplified) ---
    # 1. Get pointers to the matched expression node and the list of case nodes from the AST node (s0).
    #    ld t0, match_expr_node_offset(s0)    # t0 = matched expression node ptr
    #    ld t1, match_cases_list_offset(s0) # t1 = cases list head ptr

    # 2. Generate code to evaluate the matched expression (t0).
    #    This will leave the result in a designated register (e.g., t2 or a0).
    #    mv a0, t0 # Pass expr node
    #    mv a1, s1 # Pass code gen state
    #    jal generate_code_for_node # Call recursive code generator
    #    mv t2, a0 # Assume result is in a0, move to t2 for safety

    # 3. Generate a unique label for the end of the entire match statement.
    #    Need a helper to generate unique labels (using a counter from state s1).
    #    # mv a0, s1; jal generate_unique_label # Hypothetical helper: returns label string ptr in a0
    #    # mv s2, a0 # s2 = end_of_match_label_str_ptr

    # 4. Iterate through the case branches (starting from t1).
    #    # Need a loop structure here. Each iteration processes one case node.
    #    mv t3, t1 # t3 = current case node ptr
    #    case_loop:
    #    beq t3, zero, .L_end_case_loop # If t3 is null, end of cases

    #    # For the current case node (t3):
    #    # a. Generate a unique label for the start of this case's body.
    #    #    # mv a0, s1; jal generate_unique_label # Hypothetical helper
    #    #    # mv s4, a0 # s4 = case_body_label_str_ptr

    #    # b. Get pointer to the case pattern node.
    #    #    ld t4, case_pattern_node_offset(t3) # t4 = case pattern node ptr

    #    # c. Generate code to evaluate the case pattern (t4).
    #    #    This will leave the pattern result in a register (e.g., t5).
    #    #    mv a0, t4; mv a1, s1; jal generate_code_for_node # Call recursive code generator
    #    #    mv t5, a0 # Assume pattern result in a0, move to t5

    #    # d. Generate comparison code between the matched expression result (t2) and the pattern result (t5).
    #    #    This depends on the types being matched and the pattern kind (literal, range, etc.).
    #    #    Needs helpers for different comparisons (integer, float, string).
    #    #    # Example for integer equality:
    #    #    # beq t2, t5, .L_match_success_for_this_case # If equal, jump to case body

    #    # e. If the comparison fails, generate a conditional branch to jump to the *next* case's label
    #    #    (or the end_of_match_label if this is the last non-default case).
    #    #    Need to get the label for the *next* case first.
    #    #    # ld t6, next_case_node_offset(t3) # Get next case node
    #    #    # beq t6, zero, .L_branch_to_end_of_match # If no next case, branch to end
    #    #    # # mv a0, t6; jal get_case_body_label # Hypothetical: returns label for next case
    #    #    # # beq t2, t5, a0 # Example: Branch to next case label if not equal (incorrect logic, need inverted branch)
    #    #    # # Correct logic: Generate branch *if not equal* to the *next* case label.
    #    #    # bne t2, t5, next_case_label_string_ptr # Requires label string in branch instruction

    #    # f. Emit the label for the start of this case's body.
    #    #    # mv a0, s4; mv a1, s1; jal emit_label # Hypothetical helper

    #    # g. Get pointer to the case body node.
    #    #    ld t4, case_body_node_offset(t3) # t4 = case body node ptr

    #    # h. Generate code for the case body (recursive call).
    #    #    mv a0, t4; mv a1, s1; jal generate_code_for_node # Call recursive code generator
    #    #    # Check return value for errors...

    #    # i. Generate an unconditional jump to the end of the entire match statement.
    #    #    # mv a0, s2; mv a1, s1; jal emit_jump # Hypothetical helper (jump to end_of_match_label)

    #    # Move to the next case node.
    #    # ld t3, next_case_node_offset(t3)
    #    # j case_loop # Continue loop

    # .L_branch_to_end_of_match:
    #    # Generate branch to end_of_match_label if no more cases and the last didn't match.
    #    # This branch is the inverse of the last comparison.
    #    # # mv a0, s2; mv a1, s1; jal emit_jump # Jump to end_of_match_label

    .L_end_case_loop:
    # --- End of Case Loop ---
    # Handle potential fallthrough if no case matched and no default case exists (should be a compile-time error handled by semantic analysis).
    # If semantic analysis guarantees exhaustiveness, code reaches here only via jumps from case bodies or the non-matching branch after the last case.

    # 5. Emit the label for the end of the entire match statement.
    #    # mv a0, s2; mv a1, s1; jal emit_label # Hypothetical helper

    # --- End of Match Translation ---

    # Function epilogue
    ld ra, 0(sp)     # Restore return address
    ld s0, 8(sp)     # Restore s0
    addi sp, sp, 16  # Restore stack pointer
    jr ra            # Return