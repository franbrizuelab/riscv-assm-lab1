.data
prompt_n:       .string "Enter number of elements: "            # Prompt for array size
error_msg:      .string "Error: Invalid number of elements."    # General error message for invalid input
input_str:      .string "Input array: "                        # Label to print before displaying the input array
result_str:     .string "Sorted array: "                       # Label to print before displaying the sorted array
newline:        .string "\n"                                   # Newline character

.text
.globl main
# -----------------------------------------------------------------------------
# Function: main
# Description: Reads the number of elements in the array and the elements 
#              themselves from the user.
# Inputs: None (reads number of elements and array values from standard input).
# Outputs: None (sorted array to standard output).
# Example:
#     Enter number of elements: 5         # Input a positive integer
#     Input array: 5 4 3 2 1              # Elements are integers separated by single spaces
#     Sorted array: 1 2 3 4 5             # Elements sorted in ascending order
# -----------------------------------------------------------------------------
main:
    # Prompt user for the number of elements.
    la      a0, prompt_n
    jal     ra, print_string

    # Read number of elements.
    jal     ra, read_int
    mv      s0, a0              # s0 = number of elements

    # Check if the number of elements is large than zero.
    blez    s0, invalid_input    # If s0 <= 0, exit the program.

    # Allocate space on heap for the array (s0 * 4 bytes)
    slli    t2, s0, 2            # t2 = s0 * 4 (bytes required)
    li      a7, 9                # Syscall code 9: sbrk (allocate heap memory)
    mv      a0, t2               # Request t2 bytes
    ecall
    mv      s1, a0               # s1 = allocated memory address (heap.data)

    # Print the "Input array:" label followed by a newline.
    la      a0, input_str
    jal     ra, print_string

    # Read the array elements.
    mv      a0, s1
    mv      a1, s0
    jal     ra, read_array

    # Sort the array
    mv      a0, s1
    mv      a1, s0
    jal     ra, sort

    # Print the "Sorted array:" label followed by a newline.
    la      a0, result_str
    jal     ra, print_string

    # Print the sorted array.
    mv      a0, s1
    mv      a1, s0
    jal     ra, print_array

finish:
    # Exit the program.
    li      a7, 10           # Syscall code 10: Exit
    ecall

invalid_input:
    # Print the error message and exit.
    la      a0, error_msg
    jal     ra, print_string
    la      a0, newline
    jal     ra, print_string

    j       finish           # Jump to program exit