.data 
     message1: .asciiz"Enter the current system: "
     message2: .asciiz"Enter the number: "
     message3: .asciiz"Enter the new system: "
     message4: .asciiz"The number in the new system: "
     newline:  .asciiz"\n"
.text
     main:
         #current system
         li $v0,4
         la $a0,message1
         syscall
         
         # input current base
         li $v0,5
         syscall
         #store input (current base ) in $ t0
         move $t0,$v0
         
         #number
         li $v0,4
         la $a0,message2
         syscall
         
         # input number to convert
         li $v0,5
         syscall
         #store input (number) in $ t1
         move $t1,$v0
         
         #new system
         li $v0,4
         la $a0,message3
         syscall
         
         # input new base
         li $v0,5
         syscall
         #store input (new base ) in $ t2
         move $t2,$v0
         
         # newline
         li $v0,4
         la $a0,newline
         syscall
         
         # arguments 
         move $a0, $t0   # Pass current system to $a0
         move $a1, $t1   # Pass the number to convert to $a1
         move $a2, $t2   # Pass the new system to $a2
          
          # function 
         
         
          # Exit program
          li $v0, 10         
          syscall