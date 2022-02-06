@ (integers) has 3 integers - length of the unsorted list, comparison mode, duplicate removal option
@ (list) is the list of pointers to strings 

    .text
    .global start_manager, pop_stack
    .extern start_merge, start_mergesort, integers, list
start_manager:
    mov R6,#0   @ initial left index
    ldr R5,[R7] @ initial right index
    sub R5,R5,#1
    @ push initial indices on the stack
    @ top is instruction (mergsort or merge) then end index, then starting index
    str R6,[sp,#-4]!
    str R5,[sp,#-4]!
    @ go for mergesort as the first instruction
    b start_mergesort

pop_stack: @ pop the top of the stack, read the integer and go to corresponding instruction: 
@ -1 for mergesort and -2 for merge else we have emptied the stack and we can proceed towards counting the length  of the merged list
    ldr R1,[sp],#4
    cmp R1,#-2
    beq start_merge
    cmp R1,#-1
    beq start_mergesort
    ldr R11,=list
    mov R10,#0
    mov R9,R11
    b count_length
@ this counts the length of the merged list by iterating through it till we get a null address
count_length:
    ldr R1,[R9],#4
    cmp R1,#0
    beq exit_manager
    add R10,R10,#1
    b count_length

@ after everything we exit manager.s and proceed to output the answers
exit_manager:
    b start_output
