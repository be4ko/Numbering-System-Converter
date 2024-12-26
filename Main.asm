.data
message1: .asciiz "Enter the current system: "
message2: .asciiz "Enter the number: "
message3: .asciiz "Enter the new system: "
message4: .asciiz "The number in the new system: "
newline:  .asciiz "\n"
buffer:   .space 32  # Buffer to store string input

.text
main:
    # Current system
    li $v0, 4
    la $a0, message1
    syscall

    # Input current base
    li $v0, 5
    syscall
    move $t0, $v0  # Store current base in $t0

    # Number
    li $v0, 4
    la $a0, message2
    syscall

    # Input number as string
    li $v0, 8
    la $a0, buffer
    li $a1, 32  # Max buffer size
    syscall

    # Pass the address of the input number to $a0
    move $a3, $a0  # $a0 already points to buffer

    # New system
    li $v0, 4
    la $a0, message3
    syscall

    # Input new base
    li $v0, 5
    syscall
    move $t2, $v0  # Store new base in $t2

    # Newline
    li $v0, 4
    la $a0, newline
    syscall

    # Arguments
    move $a1, $t0  # Current base
    move $a2, $t2  # New base
    
    
    # function OtherToDecimal
    #jal OtherToDecimal
    #li $v0, 1
    #move $a0, $v1
    #syscall

    # Exit
    li $v0, 10
    syscall

# Inputs:
#   $a0 - the address of the number to be converted (as a string)
#   $a1 - the base of the number (2, 8, or 16)
# Output:
#   $v1 - the decimal equivalent of the input number

OtherToDecimal:
    li $v1, 0                 
    move $t0, $a3             

ProcessLoop:
    lb $t1, 0($t0)            
    beqz $t1, ConversionDone  

    li $t2, 0                 # Reset current digit value
    li $t3, '0'              
    li $t4, '9'              
    li $t5, 'A'              
    li $t6, 'F'              

    blt $t1, $t3, NextChar    # If char < '0', skip
    ble $t1, $t4, IsDigit     # If char is between '0' and '9', process as digit
    blt $t1, $t5, NextChar    # If char < 'A', skip
    ble $t1, $t6, IsHex       # If char is between 'A' and 'F', process as hex
    j NextChar                # Skip other characters

IsDigit:
    sub $t2, $t1, $t3         # Convert '0'-'9' to 0-9
    j AddToResult

IsHex:
    sub $t2, $t1, $t5         # Convert 'A'-'F' to 10-15
    addi $t2, $t2, 10         # Adjust for hex value
    j AddToResult

AddToResult:
    mul $v1, $v1, $a1         # Multiply result by base
    add $v1, $v1, $t2         # Add current digit value

NextChar:
    addi $t0, $t0, 1          # Advance to next character
    j ProcessLoop

ConversionDone:
    jr $ra                    # Return to the caller
