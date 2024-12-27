.data
message1: .asciiz "Enter the current system: "
message2: .asciiz "Enter the number: "
message3: .asciiz "Enter the new system: "
message4: .asciiz "The number in the new system: "
message5: .asciiz "Error: Invalid input number for the specified system\n"
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

    # Validate input
    move $t7, $a0        
    jal ValidateInput
    beq $v0, $zero, InvalidInput  # If validation failed, jump to error

    # Pass the address of the input number to $a0
    move $a3, $t7  # $a0 already points to buffer

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
    
    # number New system
    li $v0, 4
    la $a0, message4
    syscall
    
    # Arguments
    move $a1, $t0  # Current base
    move $a2, $t2  # New base
    
    # function OtherToDecimal
    jal OtherToDecimal

    move $a0, $v1
    jal DecimalToOther
    
    li $v0, 4
    move $a0, $v1
    syscall

    # Exit
    li $v0, 10
    syscall

InvalidInput:
    li $v0, 4
    la $a0, message5
    syscall
    
    # Exit program
    li $v0, 10
    syscall
##########################
#   Validation function  #
##########################
ValidateInput:
    move $t8, $t7        
    li $v0, 1           

ValidateLoop:
    lb $t1, ($t8)       
    beqz $t1, ValidateEnd  
    beq $t1, 10, ValidateEnd  
    
    # Convert character to numeric value
    li $t3, '0'
    li $t4, '9'
    li $t5, 'A'
    li $t6, 'F'
    
    # Check if character is digit
    blt $t1, $t3, InvalidChar
    ble $t1, $t4, IsNumericDigit
    blt $t1, $t5, InvalidChar
    ble $t1, $t6, IsHexDigit
    j InvalidChar
    
IsNumericDigit:
    sub $t2, $t1, $t3    
    bge $t2, $t0, InvalidChar  
    j NexttChar

IsHexDigit:
    sub $t2, $t1, $t5    
    addi $t2, $t2, 10
    bge $t2, $t0, InvalidChar  
    
NexttChar:
    addi $t8, $t8, 1     
    j ValidateLoop

InvalidChar:
    li $v0, 0           
    
ValidateEnd:
    jr $ra

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

    blt $t1, $t3, NextCharr    # If char < '0', skip
    ble $t1, $t4, IsDigit     # If char is between '0' and '9', process as digit
    blt $t1, $t5, NextCharr   # If char < 'A', skip
    ble $t1, $t6, IsHex       # If char is between 'A' and 'F', process as hex
    j NextCharr                # Skip other characters

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

NextCharr:
    addi $t0, $t0, 1          # Advance to next character
    j ProcessLoop

ConversionDone:
    jr $ra                    # Return to the caller

############################################################################################
############################################################################################
############################################################################################
############################################################################################

DecimalToOther:
    li $v1, 0          # Clear the result
    move $t0, $a0      # The decimal value in $a0
    move $t1, $a3      # The buffer address in $a3
    li $t2, 0          # Buffer index
    li $t4, 10
Loop:
    beqz $t0, Done     # If $t0 is 0, done
    div $t0, $a2       # Divide $t0 by the base ($a2)
    mfhi $t3           # Remainder from division
    mflo $t0           # Quotient from division

    # If remainder >= 10
    blt $t3, $t4, ConvertDigitToChar
    addi $t3, $t3, 55   # A - Z
    j StoreChar

ConvertDigitToChar:
    addi $t3, $t3, 48   # to 0-9 

StoreChar:
    sb $t3, 0($t1)      # Store in the buffer
    addi $t1, $t1, 1    # Increment 
    j Loop

Done:
    sb $zero, 0($t1)    # Add Null terminator
    sub $t1, $t1, 1     # Step back
    move $t5, $a3       # Start of the buffer
ReverseLoop:
    bge $t5, $t1, ReverseDone  # If start >= end go to ReverseDone
    lb $t6, 0($t5)      # Load character from the right
    lb $t7, 0($t1)      # Load character from the left
    sb $t7, 0($t5)      # Store end character at right ( swap )
    sb $t6, 0($t1)      # Store start character at end ( swap )
    addi $t5, $t5, 1    
    addi $t1, $t1, -1    
    j ReverseLoop

ReverseDone:
    move $v1, $a3
    jr $ra              # Return to the caller
