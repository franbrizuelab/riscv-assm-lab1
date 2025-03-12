.text
# -----------------------------------------------------------------------------
# Function: recursive
# Description: Calculate recursive function, as defined in Lab 1 instruction.
# Inputs:
#   a0 - Integer input x.
# Outputs:
#   a0 - Computed result F(x).
# Example:
#     x = 5
#     F(x) =  5
# -----------------------------------------------------------------------------
.globl recursive
recursive:

    #TODO
    #Let's jsut do a factorial fuinction frist to understand this recursive thing
    addi sp, sp -8          #Save space for 2 words
    sw a0, 4(sp)
    sw ra, 0(sp)
    addi t0, zero, 1        #Create a dummy variable to chek if it is one
    bgt a0, t0, else #Recursion when a0 > 1
    addi sp, sp, 8          #nothing happened, return stack to previous address
    jr ra                   # If not, finish
    
else:
    #It is greater than 1, se we need to subtract 
    addi a0, a0, -1         # a0--
    jal recursive           #Recursive call 
    lw t1, 4(sp)            #a0+1 goes to t1
    lw ra 0(sp)
    addi sp, sp, 8           #stack restored to pre. state
    mul a0, t1, a0
    jr ra
  
