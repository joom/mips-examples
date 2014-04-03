# Cumhur Korkut
# Asks for the next input to insert at the end of the array. Then prints it. Never ends.

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
    sw $v0, ($t2)
    addi $t2, $t2, 4      #increase last address by 4


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