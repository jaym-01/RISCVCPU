.text
main:
    addi    a0, zero, 0x1       # a0 is light output
    addi    a1, zero, 0x10      # a1 is countdown, 1s ~ 48 clock cycles

    jal    ra, iloop            # ra is #x1 defined as return address, subroutine
    sub    a0, a0, a0           # set a0 to 0
    jal    ra, end              # prevents the program from repeating when complete
iloop:
    addi    a1, a1, -1          # decrement a1 
    bne     a1, zero, iloop     # if counter not equals to 0, loop
mloop:     
    add     a0, a0, a0          # increment a0 once a1 has counted down
    addi    a0, a0, 1           # fill in the gap (LSB) caused by shifting
    addi    t2, zero, 0x1FF     # set t2 to 0x1FF (values after all lights are on)
    addi    a1, zero, 0x10      # reset a1 
    bne     a0, t2, iloop       # if t2 is 9, return to inner loop
    ret                         # runs JALR zero, ra, 0 (PC := ra + 0, zero = PC + 4)
end:
