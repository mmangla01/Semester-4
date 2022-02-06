@*****************taking input**************
   .text
    @ .global print_initial
    @ .extern manager
print_initial:
    @ ldr R1,=PRI_space
    @ ldr R9,=initial_str
    @ str R9,[R1,#4]
    @ mov R0,#0x05
    @ swi 0x123456
    ldr R2,=empty
    ldr R7,=integers
    mov R6,#0
    mov R4,R2
    bl read_input_help
    bl strtoint
    mov R4,R2
    bl read_input_help
    add R7,R7,#4
    bl strtoint
    mov R4,R2
    bl read_input_help
    add R7,R7,#4
    bl strtoint
    mov R4,R2
    bl read_input_help
    add R7,R7,#4
    bl strtoint
    sub R7,R7,#12
    mov R4,R2
    ldr R6,[R7]
    mov R8,#0
    bl read_input
    @ mov R5,R2
    ldr R6,[R7,#4]
    mov R8,#0
    bl read_input
    ldr R8,=list1
    ldr R9,=list2
    ldr R5,[R7]
    mov R3,R8
    mov R6,#0
    bl pointer_list
    ldr R5,[R7,#4]
    mov R3,R9
    mov R6,#0
    bl pointer_list
    mov R0,#0x18
    swi 0x123456
    @ bl manager
read_input:
    cmp R8,R6
    beq MOVPCLR
read_input_help: @R6,R2,R8
    @R0,R1,R3
    mov R0,#0x06
    ldr R1,=read_char
    swi 0x123456
    ldr R0,[R1,#4]
    ldrb R3,[R0]
    strb R3,[R2],#1
    cmp R3,#0x0d
    bne read_input_help
    mov R3,#0x00
    strb R3,[R2],#1
    @R0,R1,R3 is free
    cmp R6,#0
    @ mov pc,lr
    beq MOVPCLR
    add R8,R8,#1
    b read_input
    
strtoint:@R4
    @R8
    ldrb R8,[R4],#1
    cmp R8,#0x00
    beq MOVPCLR
@     mov pc,lr
@ continue:
    sub R8,R8,#48
    ldr R9,[R7]
    mul R9,R9,#10
    add R9,R9,R8
    str R9,[R7]
    b strtoint

MOVPCLR: mov pc,lr
increase:
    add R4,R4,#1
    cmp R4,#0x00
    bne increase
    add R4,R4,#1
    cmp R6,R5
    beq MOVPCLR
pointer_list:
    str R4,[R3],#4
    add R6,R6,#1
    b increase


write_output_help:
    ldr R1,=PRI_space
    str R4,[R1,#4]
    mov R0,#0x05
    swi 0x123456
    mov pc,lr



    .data
integers: 
    .int 0,0,0,0
PRI_space: 
    .word 1,0,89
read_char:
    .word 0
    .word .skip 1 @ address of input buffer
    .word 1 @ number of bytes to read
list1:
    .word 0
    .word .skip 1000
    .word 4
list2:
    .word 0
    .word .skip 1000
    .word 4
@ InputBuffer:
@     .skip 1
@ initial_str: 
@     .asciz "Input two strings and comprison mode (0 for case in-sensitive and 1 for case sensitive)\n"
empty:
    .space 1