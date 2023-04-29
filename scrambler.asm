
.data
input: .string "enter the message here: "
input2: .string "enter scrambeled text: "
input3: .string "enter seed: "
output1: .string "Scrambled message: "
output2: .string "original message; "
array: .space 256 # allocate space to store list of indices
buffer: .space 256	 # allocate a buffer to store the input string
buffer2: .space 256 	# allocate another buffer to store input that will consist of scrambeled text
seed: .space 256 	#allocate place to store seed
.text
main:

####################################################

###########SHOULD SEED BE INPUT???????????
###################################

#######SCRAMBLER#############

# taking input
li a7,4 	# load the syscall number for printing a string into a7
la a0, input	# load the address of the message
ecall     	# execute syscall to print the message

li a7,8  	# load the syscall number for reading a string into a7
la a0,buffer  	# load the address of the input buffer
li a1,256  	# load max number of characters to read
ecall    	# execute the syscall to read the input string

#Calculate buffer actual length to be used for random number
la x2, buffer		#address of buffer
addi x13,x0,-1		#counter to get length, -1 beacuse the buffer extra null terminator
l:
  lbu x1, 0(x2) 	#load byte
  beqz x1, exit 	#if byte is null
  addi x13,x13,1 	#increment counter
  addi x2,x2,1 	#move to next byte
  j l
  exit:
  

#Scrambler key using random number generator
li x11, 1947		#load random's seed                     <---------------------------------       ****** SEED  ****** 
la x12,buffer		#load input message address to x12
addi x14, x0, 0 	# initialize the loop counter
la x22,array		#load address of array
loop:
   
    remu x7, x11, x13	# generate a random integer less than length
    add x20,x22,x14	#address of index to store random index
    sb x7,0(x22)	#store index
     
    add x15, x0, x7	#compute the index of the character to swap
    rem x15, x15, x13	#to make sure I am chosing charecter at position i less than length of message
   
     #swap the current character with the character at the random position
    add x15,x15,x12	# address of charecter at random position
    add x17,x14,x12	#address of charecter at current position
    lb x16, 0(x15)   	# load the character at the random position
    lb x18, 0(x17)   	# load the current character
    sb x18, 0(x15)   	# store the character at the current position
    sb x16, 0(x17)   	# store the current character at the random position

    
    addi x14, x14, 1	# increment the loop counter
    blt  x14, x13, loop	#check if counter is less than length
    
li a7,4		# set the print syscall number
la,a0 ,output1	# load the address of the message
ecall     	# execute syscall to print the message

#printing scrambeled text
li a7,4   	# set the print syscall number
la a0,buffer 	# load the address of the message
ecall     	# execute syscall to print the message
    


#######Descrambler#############
li a7,4		# set the print syscall number
la a0,input2	#load the address of the message
ecall     	# execute syscall to print the message

li a7,8		# load the syscall number for reading a string 
la a0,buffer2  	# load the address of the input buffer
li a1,256 	# load max number of characters to read
ecall     	# execute the syscall to read the input string

la x3,buffer2  	#load input message to x3

li a7,4		# set the print syscall number
la a0,input3	#load the address of the message
ecall     	# execute syscall to print the message

li a7,5		# load the syscall number for reading an integer 
la a0,buffer2  	# load the address of the input buffer
li a1,256 	# load max number of characters to read
ecall     	# execute the syscall to read the input integer

la x4,seed	#load seed to x4

##This time loop should work backward
la x5, buffer2       	# load the address of the input buffer
la x6,buffer2		#load the address of input buffer again to be used to get address of charecter
add x5,x5,x13		#load address of last charecter
addi x5,x5,-1		#since x13 is length
la x24,array		#load address of list of indices
add x24,x24,x13  		#load address of last index
addi x24,x24,-1		#since x13 is length
addi x14, x0, 0 	# initialize the loop counter

loop2:
	sub x24,x24,x14 	#compute index of random index
   	
   	  #swap the current character with the character at the random position
    	add x25,x24,x6		# address of charecter at random position
   	sub x26,x5,x14		#address of charecter at current position
   	lb x27, 0(x25)   	# load the character at the random position
   	lb x28, 0(x26)   	# load the current character
   	sb x28, 0(x25)   	# store the character at the current position
    	sb x27, 0(x26)   	# store the current character at the random position

    
    	addi x14, x14, 1	# increment the loop counter
	blt  x14, x13, loop2	#check if counter is less than length
	
li a7,4		# set the print syscall number
la,a0 ,output2	# load the address of the message
ecall     	# execute syscall to print the message

#printing scrambeled text
li a7,4   	# set the print syscall number
la a0,buffer2 	# load the address of the scrambeled message that is now discrambled
ecall  
