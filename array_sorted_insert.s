# Cumhur Korkut
# Asks for the next input to insert. Array always kept sorted. Then prints it. Never ends.

.data #let processor know we will be submitting data to program now
prompt:
    .asciiz "\nInsert: " #in unused memory store this string with address prompt
left_bracket:
    .asciiz "[" #in unused memory store this string with address left_bracket
right_bracket:
    .asciiz "]" #in unused memory store this string with address right_bracket
comma:
    .asciiz "," #in unused memory store this string with address comma

size_string:
    .asciiz "\nSize of array: "

.text #enables text input / output, kind of like String.h in C++

main:
    move $t1, $a1
    move $t2, $a1
    j program

program:
    li    $v0, 4           #Prompt user for input
    la    $a0, prompt
    syscall
    li    $v0, 5           #Read n from console
    syscall

insert:
    #sw   $v0, ($t2)
    #addi $t2, $t2, 4      #increase last address by 4
    move $t1, $a1         # refresh starting address

    move $t3, $t1         # keep the current address in t3
    bne  $t1, $t2, insert_loop # go to loop if not empty array

    #add to beginning if empty array
    sw   $v0, ($t1)
    addi $t2, $t2, 4      #increase last address by 4
    j end_loop_insert

insert_loop:
    lw   $t4, ($t3)         # keep the value of current address in t4

    slt  $t5, $t4, $v0      # checks if $v0 (input) > $t4 (value of current address), keeps result in $t5

    beq  $t3, $t2, insert_last # if last value, add to the end
    beq  $t5, 1, insert_next # if input greater than the value at current address, try the next
    #otherwise insert input here

    sw   $v0, ($t3)
    addi $t2, $t2, 4      #increase last address by 4

    bne $t3, $t2, insert_shift #if not the last, shift the rest

insert_last:
    sw   $v0, ($t2) #add input to the last index of the array
    addi $t2, $t2, 4 #update the last address of array
    j print

insert_next:
    addi $t3, $t3, 4
    j insert_loop

insert_shift:
    addi $t3, $t3, 4
    lw   $t6, ($t3)         # keep the value of current address in t6
    sw   $t4, ($t3)         # save the misplaced value from the previous one 
    addi  $t4, $t6, 0       # update the last misplaced value with the one happening now
    beq  $t3, $t2, end_loop_insert # end shift loop if this was the last one
    j insert_shift

end_loop_insert:
    j print

# ARRAY PRINT
print:
    la $a0, left_bracket #load address left_bracket from memory and store it into argument register 0
    li $v0, 4 #loads the value 4 into register $v0 which is the op code for print string
    syscall   #reads register $v0 for op code, sees 4 and prints the string located in $a0

    move $t1, $a1  # load the stack beginning address

    loop_print:
        lw $t0, ($t1) #load from stack to $t0
        li $v0, 1
        move $a0, $t0
        syscall

        addi $t1, $t1, 4
        beq $t1, $t2, end_loop_print
        la $a0, comma #load address comma from memory and store it into argument register 0
        li $v0, 4 #loads the value 4 into register $v0 which is the op code for print string
        syscall #reads register $v0 for op code, sees 4 and prints the string located in $a0

        bne $t1, $t2, loop_print

    end_loop_print:
        la $a0, right_bracket #load address right_bracket from memory and store it into argument register 0
        li $v0, 4 #loads the value 4 into register $v0 which is the op code for print string
        syscall #reads register $v0 for op code, sees 4 and prints the string located in $a0

j program