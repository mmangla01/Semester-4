@ top of the stack has right index for mergespot and the second element in the stack is left index 
    
    .text
    .global start_mergesort
    .extern pop_stack

start_mergesort: 
    @ pop 2 elements: top is the right, then is the left
    ldr R5,[sp],#4
    ldr R6,[sp],#4
    cmp R6,R5 @if the left is equal to left then nothing to be done
    beq pop_stack
    add R4,R6,R5 @else we apply the algorithm for mergesort 
    mov R0,#0
    bl div_by_two
    @ push the merge instruction with left right and mid
    str R6,[sp,#-4]!
    str R0,[sp,#-4]!
    str R5,[sp,#-4]!
    mov R1,#-2
    str R1,[sp,#-4]!
    @push the mergesort instruction for the left and mid
    str R6,[sp,#-4]!
    str R0,[sp,#-4]!
    mov R1,#-1
    str R1,[sp,#-4]!
    @push the mergesort instruction for the right and mid
    add R0,R0,#1
    str R0,[sp,#-4]!
    str R5,[sp,#-4]!
    mov R1,#-1
    str R1,[sp,#-4]!
    @ now move to next instruction in the stack
    b pop_stack
    
@ helper to divide be 2
div_by_two:
    cmp R4,#2
    movlt pc,lr 
    sub R4,R4,#2
    add R0,R0,#1
    b div_by_two
    

    