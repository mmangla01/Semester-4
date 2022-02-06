@******** comparing two strings *********
@********0 for case in-sensetive*********
@******** 1 for case isensetive *********

@ input two strings and one string (comp_mode)
@ store string 1 in r4 and string 2 in r5
@ stroe the comp mode in r6


    .text
    .global manager

manager: @ edit the comparator mode 
    @ ldr r4,=string1
    @ ldr r5,=string2
    @ mov r8,#49
    mov r0,#0
    mov r1,#0
    mov r2,#0
    mov r3, #0
    ldrb r8,[r6],#1
    cmp r8,#49
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
    @ mov r3,#38
    @ str r3 ,[r1,#8]
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
    

    .data
words: .word 1,0,100 

string1: 
    .asciz "Mayank mangla\n"
string2: 
    .asciz "mayank mangla\n"
less_than:
    .asciz "First String Less than Second String\n"
    .skip 62
equal_to:
    .asciz "First String Equals Second String\n"
    @ .skip 65
greater_than:
    .asciz "First String Greater than Second String\n"
    @ .skip 59
@ new_line:
@     .asciz "\n"
