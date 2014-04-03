# Cumhur Korkut
# Program that creates an array of the size given by the user. Then counts it.
# Ex: 5 --> [1,2,3,4,5]

.data #let processor know we will be submitting data to program now
    prompt:
        .asciiz "Create an array in size: " #in unused memory store this string with address prompt
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
    li    $v0, 4           #Prompt user for input
    la    $a0, prompt
    syscall
    li    $v0, 5           #Read n from console
    syscall

    mul $t3, $v0, 4        #$t3 stores array size with offset 4

    li $t0, 0
    move $t1, $a1
    add $t2, $a1, $t3      #$t2 stores array bound

fill_array:
    addi, $t0, $t0, 1 #You can change this line to change the difference between array elements, ex: 2 for [2,4,..]
    sw $t0, ($t1)
    addi $t1, $t1, 4
    bne $t1, $t2, fill_array


# ARRAY PRINT
print:
    la $a0, left_bracket #load address left_bracket from memory and store it into argument register 0
    li $v0, 4 #loads the value 4 into register $v0 which is the op code for print string
    syscall   #reads register $v0 for op code, sees 4 and prints the string located in $a0

    move $t1, $a1  # load the stack to $t1

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



# ARRAY SIZE COUNT
size_of_array:
    la $a0, size_string #load address size_string from memory and store it into argument register 0
    li $v0, 4 #loads the value 4 into register $v0 which is the op code for print string
    syscall #reads register $v0 for op code, sees 4 and prints the string located in $a0

    move $t1, $a1 #load stack to $t1
    li $t9, 0 #initialize counter $t9

    loop_size:
        addi $t9, 1 # increase counter $t9
        lw $t0, ($t1) #load from stack to $t0

        addi $t1, $t1, 4
        beq $t1, $t2, end_loop_size
        
        #la $a0, comma #load address comma from memory and store it into argument register 0
        #li $v0, 4 #loads the value 4 into register $v0 which is the op code for print string
        #syscall #reads register $v0 for op code, sees 4 and prints the string located in $a0

        bne $t1, $t2, loop_size

    end_loop_size:
        li $v0, 1
        move $a0, $t9
        syscall #reads register $v0 for op code, sees 4 and prints the string located in $a0

li    $v0, 10          #exit
syscall