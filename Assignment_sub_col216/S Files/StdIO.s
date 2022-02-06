@*****************taking input**************
   .text
    .global print_initial
    .extern manager
print_initial:
    ldr r1,=PRI_space
    ldr r9,=initial_str
    str r9,[r1,#4]
    mov r0,#0x05
    swi 0x123456
    ldr r2,=empty
    mov r4,r2
    bl read_input_help
    mov r5,r2
    bl read_input_help
    mov r6,r2
    bl read_input_help
    bl manager

read_input_help: 
    mov r0,#0x06
    ldr r1,=read_char
    swi 0x123456
    ldr r0,[r1,#4]
    ldrb r3,[r0]
    strb r3,[r2],#1
    cmp r3,#0x0d
    bne read_input_help
    mov r3,#0x00
    strb r3,[r2],#1
    mov pc,lr
    
write_output_help:
    ldr r1,=PRI_space
    str r5,[r1,#4]
    mov r0,#0x05
    swi 0x123456
    mov pc,lr



    .data
PRI_space: 
    .word 1,0,89
read_char:
    .word 0
    .word InputBuffer @ address of input buffer
    .word 1 @ number of bytes to read
InputBuffer:
    .skip 1
initial_str: 
    .asciz "Input two strings and comprison mode (0 for case in-sensitive and 1 for case sensitive)\n"
empty:
    .space 1