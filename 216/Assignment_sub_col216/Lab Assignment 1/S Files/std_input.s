@*****************taking input**************
   .text
   .global start
start:
    ldr R1,=PRI_list1
    mov R0,#0x05
    swi 0x123456
    ldr R2,=empty
    ldr R7,=integers
    mov R6,#0
    mov R4,R2
    mov R9,R2
    bl read_input_help
    bl strtoint
    ldr R1,=PRI_list2
    mov R0,#0x05
    swi 0x123456
    mov R4,R9
    mov R2,R4
    bl read_input_help
    add R7,R7,#4
    bl strtoint
    mov R4,R9
    mov R2,R4
    ldr R1,=PRI_comp
    mov R0,#0x05
    swi 0x123456
    bl read_input_help
    add R7,R7,#4
    bl strtoint
    mov R4,R9
    mov R2,R4
    ldr R1,=PRI_duplicate
    mov R0,#0x05
    swi 0x123456
    bl read_input_help
    add R7,R7,#4
    bl strtoint
    sub R7,R7,#12
    mov R4,R9
    mov R2,R4
    ldr R6,[R7]
    mov R8,#0
    ldr R1,=PRI_string1
    mov R0,#0x05
    swi 0x123456
    bl read_input
    ldr R6,[R7,#4]
    mov R8,#0
    ldr R1,=PRI_string2
    mov R0,#0x05
    swi 0x123456
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
    b exitInput

read_input:
    cmp R8,R6
    beq MOVPCLR
read_input_help:
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
    cmp R6,#0
    beq MOVPCLR
    add R8,R8,#1
    b read_input
    
strtoint:
    ldrb R8,[R4],#1
    cmp R8,#0x0d
    beq MOVPCLR
    sub R8,R8,#48
    ldr R0,[R7]
    mov R1,#10
    mla R0,R0,R1,R8
    str R0,[R7]
    b strtoint

inc_address:
    add R4,R4,#1
    ldrb R0,[R4]
    cmp R0,#0x00
    bne inc_address
    add R4,R4,#1
    cmp R6,R5
    beq MOVPCLR
pointer_list:
    str R4,[R3],#4
    add R6,R6,#1
    b inc_address

MOVPCLR: mov pc,lr
exitInput: 
    mov R0,#0x18
    swi 0x123456
    
@ R7 has 4 integers - length of first list, length of second list, comparison mode, duplicate removal option
@ R8 is first list (addresses to first character of the strings in first list)
@ R9 is second list (addresses to first character of the strings in second list)

    .data
list1_str:
    .asciz "Please enter the length of list 1 (< 25) : "
list2_str:
    .asciz "Please enter the length of list 2 (< 25) : "
comp:
    .asciz "Please enter 0 for case sensitive and 1 for case in-sensitive merge: "
duplicate:
    .asciz "Please enter 0 for duplicate inclusive and 1 for duplicate exclusive merge: "
strings1:
    .asciz "Enter the strings for first list\n"
strings2:
    .asciz "Enter the strings for second list\n"
integers: 
    .int 0,0,0,0
PRI_list1: 
    .word 1
    .word list1_str
    .word 43
PRI_list2:
    .word 1
    .word list2_str
    .word 43
PRI_comp: 
    .word 1
    .word comp
    .word 69
PRI_duplicate: 
    .word 1
    .word duplicate
    .word 76
PRI_string1:
    .word 1
    .word strings1
    .word 34
PRI_string2:
    .word 1
    .word strings2
    .word 34
read_char:
    .word 0
    .word skip1
    .word 1 
list1:
    .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
list2:
    .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
skip1: .skip 1
empty:
    .space 1