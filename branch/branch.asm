.data 

evenmsg: .string "Even!\n" # String says it's pair
oddmsg: .string "Odd!\n" # String says it's odd
.text
# -----------------------------------------------------------------------------
# Function: branch
# Description: Calculate branch function, as defined in Lab 1 instruction.
# Inputs:
#   a0 - Integer input x.
# Outputs:
#   a0 - Computed result F(x).
# -----------------------------------------------------------------------------
.globl branch
branch:
    
    addi s0, zero, 2
    #TODO
    #First, we try to separate the two cases (even and odd)
    rem s1, a0, s0
    
    beq s1, zero, odd
    la a0, evenmsg
    li a7, 4
    ecall
    li a7, 10

    odd:
    la a0, oddmsg
    li a7, 4
    ecall

    li a7, 10   #End the program
  jr 
