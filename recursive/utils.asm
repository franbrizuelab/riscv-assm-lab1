.data
newline:    .string "\n"        # Newline string
space:      .string " "         # Space string
buffer:     .space 100          # Buffer for input string (max 100 chars)

.text

# ----------------------------------------------------------------------------- 
# Function: read_string
# Description: Reads a string from the terminal into a buffer.
# Inputs:
#   a0 - Address of buffer.
#   a1 - Maximum length.
# Outputs: None.
# -----------------------------------------------------------------------------
.globl read_string
read_string:
    li      a7, 8               # Environment code 8: Read string
    ecall
    jr      ra                  # Return

# ----------------------------------------------------------------------------- 
# Function: read_int
# Description: Reads an integer from terminal input.
# Inputs: None.
# Outputs: The read integer is returned in a0.
# -----------------------------------------------------------------------------
.globl read_int
read_int:
    li      a7, 5               # Environment code 5: Read integer
    ecall
    jr      ra                  # Return

# ----------------------------------------------------------------------------- 
# Function: print_int
# Description: Prints an integer.
# Inputs: a0 - The integer to print.
# Outputs: None.
# -----------------------------------------------------------------------------
.globl print_int
print_int:
    li      a7, 1               # Environment code 1: Print integer
    ecall
    jr      ra                  # Return

# ----------------------------------------------------------------------------- 
# Function: print_string
# Description: Prints a null-terminated string.
# Inputs: a0 - Address of the string.
# Outputs: None.
# -----------------------------------------------------------------------------
.globl print_string
print_string:
    li      a7, 4               # Environment code 4: Print string
    ecall
    jr      ra                  # Return

# ----------------------------------------------------------------------------- 
# Function: read_array
# Description: Reads space-separated integers from terminal input and stores 
#              them in an array.
# Inputs:
#   a0 - Base address of the array.
#   a1 - Maximum number of elements to read.
# Outputs: None.
# -----------------------------------------------------------------------------
.globl read_array
read_array:
    # Save callee-saved registers: ra, s0, s1.
    addi    sp, sp, -12         # Allocate stack space
    sw      ra, 8(sp)
    sw      s0, 4(sp)
    sw      s1, 0(sp)

    mv      s0, a0              # s0 = Base address of the array
    mv      s1, a1              # s1 = Maximum number of elements

    # Read user input into buffer using read_string function
    la      a0, buffer          # Load buffer address
    li      a1, 100             # Max length 100
    jal     read_string         # Call read_string

    # Parse input and store numbers in array
    la      a0, buffer          # a0 = Buffer start address
    mv      a1, s0              # a1 = Base address of the array
    mv      a2, s1              # a2 = Maximum number of elements
    jal     parse_input         # Call parse function

    # Restore saved registers
    lw      ra, 8(sp)
    lw      s0, 4(sp)
    lw      s1, 0(sp)
    addi    sp, sp, 12          # Deallocate stack space
    jr      ra                  # Return

# ----------------------------------------------------------------------------- 
# Function: parse_input
# Description: Parses space-separated integers from a string and stores them in
#              an array.
# Inputs:
#   a0 - Address of input string.
#   a1 - Base address of the array.
#   a2 - Maximum number of elements.
# Outputs: None.
# -----------------------------------------------------------------------------
parse_input:
    li      t0, 0               # Element counter (i = 0)
    li      t1, 0               # Current number being parsed
    li      t6, 1               # t6 = Sign multiplier (1 for positive, -1 for negative)
    la      t2, buffer          # Pointer to input buffer

parse_loop:
    lb      t3, 0(t2)           # Load character from buffer
    li      t4, 10              # ASCII for newline ('\n')
    beq     t3, t4, store_last  # If newline, store last number and exit

    li      t4, 32              # ASCII for space (' ')
    beq     t3, t4, store_number # If space, store parsed number

    li      t4, 45              # ASCII for '-'
    beq     t3, t4, set_negative # If '-', set negative sign

    li      t4, 48              # ASCII for '0'
    blt     t3, t4, next_char   # If not a digit, skip
    li      t4, 57              # ASCII for '9'
    bgt     t3, t4, next_char   # If not a digit, skip

    # Convert ASCII to integer
    li      t4, 48              # '0' ASCII offset
    sub     t3, t3, t4          # Convert character to number
    li      t4, 10
    mul     t1, t1, t4          # Multiply current number by 10
    add     t1, t1, t3          # Add new digit to current number
    j       next_char

set_negative:
    li      t6, -1              # Set sign multiplier to -1
    j       next_char           # Continue parsing

store_number:
    beq     t0, a2, parse_done  # If max elements reached, stop
    mul     t1, t1, t6          # Apply sign to number
    slli    t4, t0, 2           # t4 = i * 4 (array offset)
    add     t5, a1, t4          # t5 = Address of array[i]
    sw      t1, 0(t5)           # Store parsed number

    addi    t0, t0, 1           # i++
    li      t1, 0               # Reset current number
    li      t6, 1               # Reset sign multiplier to positive
    j       next_char

next_char:
    addi    t2, t2, 1           # Move to next character
    j       parse_loop

store_last:
    beqz    t1, parse_done      # If last number is empty, do nothing
    beq     t0, a2, parse_done  # If max elements reached, stop
    mul     t1, t1, t6          # Apply sign to number
    slli    t4, t0, 2           # t4 = i * 4 (array offset)
    add     t5, a1, t4          # t5 = Address of array[i]
    sw      t1, 0(t5)           # Store parsed number

parse_done:
    jr      ra                  # Return

# ----------------------------------------------------------------------------- 
# Function: print_array
# Description: Prints an array of integers.
# Inputs:
#   a0 - Base address of the array.
#   a1 - Number of elements to print.
# Outputs: None.
# -----------------------------------------------------------------------------
.globl print_array
print_array:
    # Save callee-saved registers: ra, s0, s1.
    addi    sp, sp, -12
    sw      ra, 8(sp)
    sw      s0, 4(sp)
    sw      s1, 0(sp)

    mv      s0, a0              # s0 = Base address of the array.
    mv      s1, a1              # s1 = Number of elements.
    li      t0, 0               # t0 = Loop counter (i = 0).

print_array_loop:
    beq     t0, s1, print_array_done  # If i equals the number of elements, exit loop.

    slli    t1, t0, 2           # t1 = i * 4 (byte offset)
    add     t2, s0, t1          # t2 = Address of array[i]
    lw      a0, 0(t2)           # Load the integer
    jal     print_int           # Call print_int function

    addi    t0, t0, 1           # Increment i
    beq     t0, s1, print_array_newline  
    la      a0, space
    jal     print_string        # Call print_string function
    j       print_array_loop    

print_array_newline:
    la      a0, newline
    jal     print_string        # Call print_string function

print_array_done:
    lw      ra, 8(sp)
    lw      s0, 4(sp)
    lw      s1, 0(sp)
    addi    sp, sp, 12
    jr      ra                  # Return