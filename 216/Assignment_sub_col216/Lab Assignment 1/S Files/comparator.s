@******** comparing two strings *********
@********0 for case in-sensetive*********
@******** 1 for case isensetive *********
    .text
    .global manager
manager: 
    ldr r1,=PRI_space
    ldr r2,=initial_str
    str r2,[r1,#4]
    mov r0,#0x05
    swi 0x123456
    ldr r2,=empty
    mov r4,r2
    bl read_input
    mov r5,r2
    bl read_input
    mov r6,r2
    bl read_input
    ldrb r1,[r6],#1
    cmp r1,#49
    beq comparator_1
    bl comparator_2

comparator_1:
    ldrb r2,[r4],#1
    ldrb r3,[r5],#1
    cmp r2,r3
    blt one_lt_two
    bgt one_gt_two
    cmp r2,#0x00
    beq one_eq_two
    bl comparator_1

comparator_2:
    ldrb r2,[r4],#1
    ldrb r3,[r5],#1
    cmp r3,#91
    bgt moderate_1
m1:    cmp r2,#91
    bgt moderate_2
m2:    cmp r2,r3
    blt one_lt_two
    bgt one_gt_two
    cmp r2,#0x00
    beq one_eq_two
    bl comparator_2
moderate_1:
    sub r3,r3,#32
    bl m1
moderate_2:
    sub r2,r2,#32
    bl m2

one_lt_two:
    ldr r1,=words
    ldr r2,=less_than
    str r2,[r1,#4]
    mov r3,#38
    str r3 ,[r1,#8]
    mov r0,#0x05
    swi 0x123456
    mov r0, #0x18
    swi 0x123456
one_gt_two:
    ldr r1,=words
    ldr r2,=greater_than
    str r2,[r1,#4]
    mov r2,#41
    str r2 ,[r1,#8 ]
    mov r0,#0x05
    swi 0x123456
    mov r0, #0x18
    swi 0x123456
one_eq_two:
    ldr r1,=words
    ldr r2,=equal_to
    str r2,[r1,#4]
    mov r2,#35
    str r2 ,[r1,#8]
    mov r0,#0x05
    swi 0x123456
    mov r0, #0x18
    swi 0x123456
    
read_input: 
    mov r0,#0x06
    ldr r1,=read_char
    swi 0x123456
    ldr r0,[r1,#4]
    ldrb r3,[r0]
    strb r3,[r2],#1
    cmp r3,#0x0d
    bne read_input
    mov r3,#0x00
    strb r3,[r2],#1
    mov pc,lr

    .data
words: 
    .word 1,0,0
PRI_space: 
    .word 1,0,89
read_char:
    .word 0
    .word InputBuffer 
    .word 1
InputBuffer:
    .skip 1
initial_str: 
    .asciz "Input two strings and comprison mode (0 for case in-sensitive and 1 for case sensitive)\n"
less_than:
    .asciz "First String Less than Second String\n"
equal_to:
    .asciz "First String Equals Second String\n"
greater_than:
    .asciz "First String Greater than Second String\n"
empty:
    .space 1
