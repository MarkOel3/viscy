    .org 0x000
    .start
    
    XOR   r0, r0, r0
    XOR   r1, r1, r1
    XOR   r2, r2, r2
    XOR   r3, r3, r3
    XOR   r7, r7, r7
    LDIH  r7, 0x01
    LDIL  r7, 0x00
    LD    r0, [r7]  ; first multiplicant in r0

    LDIL  r7, 0x01
    LD    r2, [r7]  ; second multiplicant in r0

    sal  r3, r0
    LDIH r3, 0x00
    SAL  r3, r3
    SAL  r3, r3
    SAL  r3, r3
    SAL  r3, r3
    SAL  r3, r3
    SAL  r3, r3
    LDIH r3, 0x00 ; if r0 LSB 1 war ist r3 jetzt ungleich 0
    
    
    ;LDIL  r5, loop
    ;LDIH  r5, loop>>8

    HALT


    .org 0x100
    result: .data 0x01, 0x02
            .res 4

    .end