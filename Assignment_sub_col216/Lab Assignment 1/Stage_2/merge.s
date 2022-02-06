@ R7 has 4 integers - length of first list, length of second list, comparison mode, duplicate removal option
@ R8 is first list (addresses to first character of the strings in first list)
@ R9 is second list (addresses to first character of the strings in second list)

        .text
        .global manager
        .extern manageWrite
manager: 
        ldr R6,=merged
        mov R11,R6
        ldr R0,[R7,#8]  
        ldr R1,[R7,#12] 
        mov R10,#0

getElement:
        ldr R4,[R8]  
        ldr R5,[R9]  
        cmp R0,#1
        beq comparator_1
        b comparator_2

comparator_1:
        ldrb R2,[R4],#1
        ldrb R3,[R5],#1
        cmp R2,R3
        blt addFromFirst
        bgt addFromSecond
        cmp R2,#0x00
        beq checkForBoth
        b comparator_1

comparator_2:
        ldrb R2,[R4],#1
        ldrb R3,[R5],#1
        cmp R3,#91
        bgt moderate_1
m1:     cmp R2,#91
        bgt moderate_2
m2:     cmp R2,R3
        blt addFromFirst
        bgt addFromSecond
        cmp R2,#0x00
        beq checkForBoth
        bl comparator_2
moderate_1:
        sub R3,R3,#32
        bl m1
moderate_2:
        sub R2,R2,#32
        bl m2

addFromFirst:
        ldr R2,[R8],#4
        str R2,[R6],#4
        ldr R2,[R7]
        ldr R3,[R7,#4]
        sub R2,R2,#1
        str R2,[R7]
        add R10,R10,#1
        b checkOver
addFromSecond:
        ldr R3,[R9],#4
        str R3,[R6],#4
        ldr R2,[R7]
        ldr R3,[R7,#4]
        sub R3,R3,#1
        str R3,[R7,#4]
        add R10,R10,#1
        b checkOver
checkForBoth:
        cmp R1,#1
        beq jump
        ldr R2,[R8],#4
        str R2,[R6],#4
        ldr R3,[R9],#4
        str R3,[R6],#4
        b nextInBoth
jump:   add R8,R8,#4
        ldr R3,[R9],#4
        str R3,[R6],#4
        b nextInBoth

nextInBoth:
        ldr R2,[R7]
        sub R2,R2,#1
        str R2,[R7]
        ldr R3,[R7,#4]
        sub R3,R3,#1
        str R3,[R7,#4]
        cmp R1,#0
        addeq R10,R10,#1
        add R10,R10,#1
        b checkOver

checkOver:
        cmp R3,R2
        beq doubtful
        cmp R2,#0
        beq addFromSecond
        cmp R3,#0
        beq addFromFirst
        b getElement
doubtful:
        cmp R2,#0
        beq exitMerge
        b getElement
exitMerge:
        b manageWrite
        @ move to output.s
        @ R10 => size of merged list
        @ R11 => pointer to merged list 

        
        .data
merged:
        .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
        .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
        .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
        .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0



