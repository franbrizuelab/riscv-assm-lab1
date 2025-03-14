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
    
    bne s1, zero, odd   #Go to the function for odd numbers
    #la a0, evenmsg
    srai a0, a0, 1      #Right shift by 1, which is like dividing by 2
    #li a7, 4
    #ecall
    jr ra

odd:
    addi t0, zero, 3
    mul a0, a0, t0      #The lower 32 bits uf the multiplication by 3
    addi a0, a0, 1      #Adding 1
    #la a0, oddmsg
    #li a7, 4
    #ecall
  jr ra
