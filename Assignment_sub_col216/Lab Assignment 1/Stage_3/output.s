@ R10 => size of merged list
@ R11 => pointer to merged list 

    .text
    .global start_output, exit_output
    .extern integers, list, readChar, printCharacter, printInteger, printMsgExit
    .extern printMsgInt, printMsgString, msgInt, msgString, msgExit, storeIntChar
start_output:           @initiate the output.s
    mov R8,R10
    ldr R1,=printMsgInt @ print the message for the length of the sorted list
    mov R0,#0x05
    swi 0x123456
    ldr R3,=storeIntChar    @ now we print the length of the sorted list
    mov R6,R3               @ by first converting it to equivalent string
    mov R7,#0x00
    mov R4,#10              @ int_to_str is the function that converts the integer to equivalent string
    bl int_to_str           @ and prints the integer on the console
    ldr R1,=printMsgString  @ then we print the message for the strings
    mov R0,#0x05
    swi 0x123456            @ and then by each next line character we print the next string in the sorted list
    b read_next_line

read_next_line:             @ used to read the next line character 
    cmp R10,#0              @ till we have printed the required number of strings
    beq exit_output
    mov R0,#0x06
    ldr R1,=readChar        @ command for reading one character entered in the console
    swi 0x123456
    ldr R2,[R1,#4]          @ load one byte character in the register that can be compared by the new line character
    ldrb R0,[R2] 
    cmp R0,#0x0d            @ if the entered caharcter is not next line character 
    bne read_next_line      @ then we wait for the next character
    ldr R3,[R11],#4         @ else we load the address of string that is to be printed
    sub R10,R10,#1          @ and decrease the leftover number strings
    b print_str             @ and move to print the string 

print_str:                  @ this label is used to print the string on the console
    ldrb R0,[R3]            @ byte by byte till we reach the null character
    cmp R0,#0x00
    beq read_next_line      @ if the next character is null then we wait for the next line character
    ldr R1,=printCharacter  @ else we go on printing the character
    str R3,[R1,#4]
    add R3,R3,#1            @ and increase the address of the iterator on the string
    mov R0,#0x05
    swi 0x123456            @ print instruction for the character that we got by reading the byte of the string
    b print_str

int_to_str:                 @ converting the integer from a string
    strb R7,[R3],#1         
    cmp R8,#0               @ if we have completed reading the integer 
    beq print_int           @ then we can move on printing the integer string on the console
    mov R5,#0
    b div_by_ten
div_by_ten:                 
    cmp R8,R4
    blt l1
    sub R8,R8,R4            @ division by 10 function that helps in getting the string
    add R5,R5,#1
    b div_by_ten
l1: mov R7, R8
    mov R8, R5
    b int_to_str


print_int:                  @ label that prints the integer string 
    sub R3,R3,#1            
    ldrb R0,[R3]            @ printing byte by byte
    cmp R3,R6               
    moveq R0,#0x0d
    addne R0,R0,#48         @ adding the number 48 to convert the integer into equivalent character
    strb R0,[R3]
    ldr R1,=printInteger    @ and sending it for printing
    str R3,[R1,#4]
    mov R0,#0x05
    swi 0x123456
    moveq pc,lr
    b print_int
exit_output:
    ldr R1,=printMsgExit    @ printing the end of program message
    mov R0,#0x05
    swi 0x123456            @ instruction for print and then exit
    mov R0,#0x18
    swi 0x123456            @ instruction for haulting the program