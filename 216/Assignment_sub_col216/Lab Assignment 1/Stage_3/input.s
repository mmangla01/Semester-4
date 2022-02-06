@*****************taking input**************
   .text
   .global integers, list, readChar, printCharacter, printInteger, printMsgExit 
   .global printMsgInt, printMsgString, msgInt, msgString, msgExit, storeIntChar, merged
   .extern start_manager, exit_output
start_input:
    @ reading the length of the list
    ldr R1,=printList
    mov R0,#0x05
    swi 0x123456
    ldr R2,=empty
    ldr R7,=integers
    mov R6,#0
    mov R4,R2
    mov R9,R2
    bl read_input_help
    bl str_to_int
    @reading the comparison mode
    mov R4,R9
    mov R2,R4
    ldr R1,=printComp
    mov R0,#0x05
    swi 0x123456
    bl read_input_help
    add R7,R7,#4
    bl str_to_int
    @reading the duplicacy mode
    mov R4,R9
    mov R2,R4
    ldr R1,=printDuplicate
    mov R0,#0x05
    swi 0x123456
    bl read_input_help
    add R7,R7,#4
    bl str_to_int
    sub R7,R7,#8
    @ integers done
    @error if the list is empty
    ldr R0,[R7]
    cmp R0,#0
    beq error
    @reading the strings for the list
    mov R4,R9
    mov R2,R4
    ldr R6,[R7]
    mov R8,#0
    ldr R1,=printString
    mov R0,#0x05
    swi 0x123456
    bl read_input
    @ create the list of pointers
    ldr R8,=list
    ldr R5,[R7]
    mov R3,R8
    mov R6,#0
    bl pointer_list
    b exit_input

@ read the string from the console
@ if the string is read for integer then only read_input_help is functional
read_input:
    cmp R8,R6
    moveq pc,lr
read_input_help:
    mov R0,#0x06
    ldr R1,=readChar
    swi 0x123456
    ldr R0,[R1,#4]
    ldrb R3,[R0]
    cmp R3, #0x08
    subeq R2,R2,#1
    beq read_input_help
    strb R3,[R2],#1
    cmp R3,#0x0d
    bne read_input_help
    mov R3,#0x00
    strb R3,[R2],#1
    cmp R6,#0
    moveq pc,lr
    add R8,R8,#1
    b read_input
    
@ converts the input string to corresponding integer
str_to_int:
    ldrb R8,[R4],#1
    cmp R8,#0x0d
    moveq pc,lr
    sub R8,R8,#48
    ldr R0,[R7]
    mov R1,#10
    mla R0,R0,R1,R8
    str R0,[R7]
    b str_to_int

@ here we create the list of pointers
inc_address:
    add R4,R4,#1
    ldrb R0,[R4]
    cmp R0,#0x00
    bne inc_address
    add R4,R4,#1
    cmp R6,R5
    moveq pc,lr
    b pointer_list
pointer_list:
    str R4,[R3],#4
    add R6,R6,#1
    b inc_address

@ exit and error labels: exit to manager.s if not error, otherwise exit the function
exit_input: 
    b start_manager
error:
    ldr R1,=printError
    mov R0,#0x05
    swi 0x123456
    b exit_output
    
@ (integers) has 3 integers - length of the unsorted list, comparison mode, duplicate removal option
@ (list) is the list of pointers to strings 

    .data
listStr:
    .asciz "Please enter the length of unsorted list (< 100) : "
comp:
    .asciz "Please enter 0 for case in-sensitive and 1 for case sensitive merge: "
duplicate:
    .asciz "Please enter 0 for duplicate inclusive and 1 for duplicate exclusive merge: "
strings:
    .asciz "Enter the strings for the unsorted list\n"
errorMsg:
    .asciz "ERROR: List has 0 elements\n"
    .align 4
msgInt:
    .asciz "Size of the merged list is: "
    .align 4
msgString:
    .asciz "\nThe strings in sorted list are: (Press Enter to get next string) "
    .align 4
msgExit:
    .asciz "\n -------End of Program-------- "
    .align 4
integers: 
    .int 0,0,0,0
printError: 
    .word 1
    .word errorMsg
    .word 28
printList: 
    .word 1
    .word listStr
    .word 51
printComp: 
    .word 1
    .word comp
    .word 69
printDuplicate: 
    .word 1
    .word duplicate
    .word 76
printString:
    .word 1
    .word strings
    .word 41
readChar:
    .word 0
    .word skipOne
    .word 1 
list:
    .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
merged:
    .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
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
    .word 67
printInteger:
    .word 1,0,1
printCharacter:
    .word 1,0,1
storeIntChar:
    .word 0
skipOne: 
    .skip 1 
empty:
    .space 1
