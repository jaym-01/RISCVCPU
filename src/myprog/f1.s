iloop:
    subi    a1, a1, 1           # decrement a1 
    bne     a1, zero, iloop     # if counter not equals to 0, loop
mloop:     
    addi    a0, a0, 1           # a1 is the counter, init to 0
    addi    t2, zero, 0x9       # set t2 to be 9
    bne     a0, t2, iloop       # if t2 is 9, return to main
    ret                         # runs JALR zero, ra, 0 (PC := ra + 0, zero = PC + 4)

main:
    addi    t1, zero, 0xff      # load t1 with 255
    addi    a0, zero, 0x0       # a0 is light output
    addi    a1, zero, 0x30      # a1 is countdown

    jal    ra, iloop            # ra is #x1 defined as return address, subroutine
    sub    a0, a0, a0           # set a0 to a0