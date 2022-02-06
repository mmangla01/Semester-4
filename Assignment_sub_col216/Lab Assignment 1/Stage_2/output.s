@ R10 => size of merged list
@ R11 => pointer to merged list 

    .text
    .global start_output, empty, exit_output
start_output:
    mov R8,R10
    ldr R1,=printMsgInt
    mov R0,#0x05
    swi 0x123456
    ldr R3,=storeIntChar
    mov R6,R3
    mov R7,#0x00
    mov R4,#10
    bl int_to_str
    ldr R1,=printMsgString
    mov R0,#0x05
    swi 0x123456
    b read_next_line

read_next_line:
    cmp R10,#0
    beq exitOutput
    mov R0,#0x06
    ldr R1,=read_char2
    swi 0x123456
    ldr R2,[R1,#4]
    ldrb R0,[R2] 
    cmp R0,#0x0d
    bne read_next_line
    ldr R3,[R11],#4
    sub R10,R10,#1
    b print_str

print_str:
    ldrb R0,[R3]
    cmp R0,#0x00
    beq read_next_line
    ldr R1,=printCharacter
    str R3,[R1,#4]
    add R3,R3,#1
    mov R0,#0x05
    swi 0x123456
    b print_str

int_to_str:
    strb R7,[R3],#1
    cmp R8,#0
    beq print_int
    mov R5,#0
    b div_by_ten
div_by_ten:
    cmp R8,R4
    blt l1
    sub R8,R8,R4
    add R5,R5,#1
    b div_by_ten
l1: mov R7, R8
    mov R8, R5
    b int_to_str


print_int: 
    sub R3,R3,#1
    ldrb R0,[R3]
    cmp R3,R6
    moveq R0,#0x0d
    addne R0,R0,#48
    strb R0,[R3]
    ldr R1,=printInteger
    str R3,[R1,#4]
    mov R0,#0x05
    swi 0x123456
    moveq pc,lr
    b print_int
exit_output:
    ldr R1,=printMsgExit
    mov R0,#0x05
    swi 0x123456
    mov R0,#0x18
    swi 0x123456

    .data
printMsgInt:
    .word 1
    .word msgInt
    .word 28
printMsgExit:
    .word 1
    .word msgExit
    .word 33
printMsgString:
    .word 1
    .word msgString
    .word 65
msgInt:
    .asciz "Size of the merged list is: "
    .align 4
msgString:
    .asciz "\nThe strings in merged list are: (Press Enter to get next string) "
    .align 4
msgExit:
    .asciz "\n -------End of Program-------- "
    .align 4
printInteger:
    .word 1,0,1
printCharacter:
    .word 1,0,1
length:
    .word 0
read_char2:
    .word 0
    .word inputBuffer 
    .word 1 
storeIntChar:
    .word 0
inputBuffer:
    .skip 1

empty:
    .space 1