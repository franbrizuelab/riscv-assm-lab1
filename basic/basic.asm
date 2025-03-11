.text
# -----------------------------------------------------------------------------
# Function: basic
# Description: Calculate basic function, as defined in Lab 1 instruction.
# Inputs:
#   a0 - Integer input x.
# Outputs:
#   a0 - Computed result F(x).
# -----------------------------------------------------------------------------
.globl basic
basic:

    #TODO
    addi s0,zero,1	#Set s0 to 1
    addi s1,zero,3	#Set s1 to 3 (I think t0 may not work since it doesnnt hold values between calls)
    add s2,zero,a0
    addi s3,zero,7
    
    while:
    bge s0,s1,next	#Compare s0 and s1 (while s0 != s1)
    add a0,a0,s2	#Add a0 to a0
    addi s0,s0,1     	#s0++
    j while		#continue the loop
    
    next:
    rem a0, a0, s3
    jr ra
