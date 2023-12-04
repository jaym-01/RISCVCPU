.text
main:
    addi     a1, zero, 0x23
    lui     a2, 0x10
    sb      a1, 0(a2)
    lbu     a0, 0(a2)