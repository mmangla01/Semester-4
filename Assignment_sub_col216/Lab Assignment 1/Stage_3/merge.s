@ top three elements in the stack are left, mid and right indices respectively
@ we merge two list: list[left,mid] and list[mid+1,right]


        .text
        .global start_merge
        .extern pop_stack, list, integers, merged
start_merge: 
        mov R10,#0              @ counter for the number of duplicates
        ldr R9,=merged          @ pointer to merged list
        mov R0,#4               @ constant 4 for getting initial pointers to the lists
        ldr R6,[sp]             @ right
        ldr R5,[sp,#4]          @ mid
        add R5,R5,#1            @ mid+1
        ldr R4,[sp,#8]          @ left
        ldr R3,=list            @ original list
        mov R2,R3               
        mov R1,R3
        mla R3,R0,R5,R2         @ pointer to the second list (starting from mid+1)
        mla R2,R0,R4,R1         @ pointer to the first list (starting from left)
        ldr R7,=integers
        ldr R0,[R7,#4]          @ comp mode
        ldr R1,[R7,#8]          @ duplicate
        sub R8,R6,R5
        add R8,R8,#1            @ length of list 1
        sub R7,R5,R4            @ length of list 2

@ list 1 - R2, list 2 - R3
@ length 1 = R7, length 2 = R8, counter - R10

get_element:
        ldr R4,[R2]             @ element from list 1
        ldr R5,[R3]             @ element from list 2
        cmp R4,#0               @ if null pointer of list1
        bleq doubtful_l1
        cmp R5,#0               @ if null pointer of list2
        beq doubtful_l2
        cmp R0,#1               @ check for comparison mode
        beq comparator_1
        b comparator_2

comparator_1:
        ldrb R6,[R4],#1         @ load a byte from both list 
        ldrb R11,[R5],#1        @ and compare them one by one
        cmp R6,R11              
        blt add_from_first
        bgt add_from_second
        cmp R6,#0x00            @ if both the bytes are equal to null character 
        beq check_for_both      @ then we check for both equal strings
        b comparator_1          @ else compare for the next character

comparator_2:
        ldrb R6,[R4],#1         @ load a byte from both list 
        ldrb R11,[R5],#1        @ and compare them one by one
        cmp R11,#91             @ comparing the case of the character
        bgt moderate_1          @ and moderating the case 
m1:     cmp R6,#91              
        bgt moderate_2
m2:     cmp R6,R11              
        blt add_from_first
        bgt add_from_second
        cmp R6,#0x00            @ if both the bytes are equal to null character 
        beq check_for_both      @ then we check for both equal strings
        b comparator_2          @ else compare for the next character
moderate_1:
        sub R11,R11,#32         @ moderator for string for the first list
        b m1
moderate_2:
        sub R6,R6,#32           @ moderator for string of the second list
        b m2

add_from_first:         @ adding the element from the fisrt list to the merged list
        ldr R6,[R2],#4          @ loading the element and storing to the merged list
        str R6,[R9],#4
        sub R7,R7,#1            @ and subtracting 1 from the length of the string remaining
        b check_over            @ now check for the emptiness of the list
add_from_second:        @ adding the element from the fisrt list to the merged list
        ldr R11,[R3],#4         @ loading the element and storing to the merged list
        str R11,[R9],#4
        sub R8,R8,#1            @ and subtracting 1 from the length of the string remaining
        b check_over            @ now check for the emptiness of the list
check_for_both:         @ adding element from both the lists
        cmp R1,#1               @ if the duplicates are to be removed
        beq jump                @ then we jump adding both element and rather add only one of them
        ldr R6,[R2],#4          @ else we add the elements from both the lists
        str R6,[R9],#4
        b next_in_both
jump:   add R2,R2,#4            @ in the jump we need not add the string from one list
        add R10,R10,#1          @ rather we just increase the address of the pointer of the list
        b next_in_both          @ then we move to add the required string in the merged list and updating the length of the lists

next_in_both:                   @ jumping in the list when we got both the strings equal
        sub R7,R7,#1
        sub R8,R8,#1
        ldr R11,[R3],#4         @ and adding the pointer of the other list in the merged list
        str R11,[R9],#4
        b check_over

check_over:                     @ checking if any list is over
        cmp R7,R8
        beq doubtful
        cmp R7,#0               @ if the list 1 is over
        beq add_from_second     @ then directly add from second
        cmp R8,#0               @ else if the list 2 is over 
        beq add_from_first      @ then directly add from first
        b get_element           @ else get next elements for both lists
doubtful:                       @ in case the length of both the lists is equal
        cmp R7,#0               @ we check if equal to 0
        beq exit_merge          @ if yes then we exit the merging
        b get_element           @ else we get next elements for the lists


doubtful_l1:                    @ if the list 1 starts having null pointer
        cmp R5,#0               @ and if list 2 also starts having null pointer
        beq add_null            @ then we begin adding null pointers to merged list
        b add_from_second       @ else we add element from second list

doubtful_l2:                    @ if the list 1 starts having null pointer
        cmp R4,#0               @ and if list 2 also starts having null pointer
        beq add_null            @ then we begin adding null pointers to merged list
        b add_from_first        @ else we add element from second list
add_null:                       
        add R7,R8,R7            @ adding the null pointers
        mov R0,#0
add_null_help:                  @ number of null pointers being equal to sum of remaining nulls in each list
        cmp R7,#0               @ if sufficient null pointers have been added
        beq exit_merge          @ then we exit merge
        sub R7,R7,#1            @ else we addd more null pointers
        str R0,[R9],#4
        b add_null_help


manage_duplicate:
        cmp R10,#0              @ checking if the number of duplicates is reduced to 0
        moveq pc,lr
        sub R10,R10,#1          @ else for each decreasing counter
        str R0,[R9],#4          @ we add a null pointer to the merged list
        b manage_duplicate
update_pointers:
        cmp R6,#0               @ comparing the remaining length with 0
        moveq pc,lr
        sub R6,R6,#1            @ else for each decreasing number for the length
        ldr R2,[R1],#4          @ load the pointer in the merged list
        str R2,[R3],#4          @ an store that pointer in the original list 
        b update_pointers


exit_merge:                     @ some ending operartions in merge
        ldr R6,[sp],#4          @ poping the elements from stack
        add sp, #4
        ldr R4,[sp],#4
        sub R6,R6,R4
        add R6,R6,#1            @ getting length of the list that was sent for merging
        mov R1,#4
        ldr R2,=list
        mla R3,R1,R4,R2         @ initial index of the list sent for merging
        mov R0,#0
        bl manage_duplicate     @ adding the null until we get the length of the merged list as the original one
        ldr R1,=merged
        bl update_pointers      @ update the pointers in the original list with that in the merged list
        b pop_stack
        
