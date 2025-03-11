.data
prompt_x:       .string "x = "                                  # Prompt for input x
prompt_fx:      .string "F(x) = "                              # Prompt for input F(x)
newline:        .string "\n"                                    # Newline character

.text
.globl main
# -----------------------------------------------------------------------------
# Function: main
# Description: Reads an integer input x and computes F(x) 
#              using the basic function, as defined in Lab 1 instruction.
# Inputs: None (reads x from standard input).
# Outputs: None (prints the result to standard output).
# Example:
#     x = 5             # Input a integer
#     F(x) =  1         # Output the function result 
# -----------------------------------------------------------------------------
main:
    # Prompt user for the number of elements.
    la      a0, prompt_x
    jal     ra, print_string

    # Read input x
    jal     ra, read_int

    # Calculate for F(x)
    jal     ra, basic
    mv      t0, a0

    # Print the "F(x) = " label
    la      a0, prompt_fx
    jal     ra, print_string

    # Print value of F(x)
    mv      a0, t0
    jal     ra, print_int
    la      a0, newline
    jal     ra, print_string

    # Exit the program.
    li      a7, 10           # Environment code 10: Exit
    ecall