# Inputs:
#   $a0 - the number to be converted (as a string)
#   $a1 - the base of the number (2, 8, or 16)
# Output:
#   $v0 - the decimal equivalent of the input number

OtherToDecimal:

    li $v0, 0                
    la $t0, ($a0)            

ProcessLoop:
    lb $t1, 0($t0)           # current character
    beqz $t1, ConversionDone 


    li $t2, 0                # Reset current digit value
    li $t3, '0'              
    li $t4, '9'              
    li $t5, 'A'              
    li $t6, 'F'              

    blt $t1, $t3, NextChar   
    ble $t1, $t4, IsDigit    
    blt $t1, $t5, NextChar   
    ble $t1, $t6, IsHex      
    j NextChar

IsDigit:
    sub $t2, $t1, $t3        
    j AddToResult

IsHex:
    sub $t2, $t1, $t5        
    addi $t2, $t2, 10        
    j AddToResult

AddToResult:
    mul $v0, $v0, $a1        # Multiply current result by base
    add $v0, $v0, $t2        

NextChar:
    addi $t0, $t0, 1         
    j ProcessLoop

ConversionDone:
    jr $ra                  # Return to the caller
