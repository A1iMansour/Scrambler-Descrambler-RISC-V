
.data
input: .string "enter the message here:"
input2: .string "\n enter scrambeled text:"
input3: .string "\n enter seed:"
output1: .string "Scrambled message:"
output2: .string "\n original message:"
debug: .string "\n"
output3:.string "\n this is the seed you will use for descrambler:"
buffer: .space 256	 # allocate a buffer to store the input string
buffer2: .space 256 	# allocate another buffer to store input that will consist of scrambeled text
seed: .space 256 	#allocate place to store seed
.text
main:



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
li x11, 563		#load random's seed                     <---------------------------------       ****** SEED  ****** 
la x12,buffer		#load input message address to x12
la x30,buffer		#load input message address to x30
li x14, 0 	# initialize the loop counter

loop:
   	la x12,buffer
   	remu x7, x11, x13	# generate a random integer less than length
    	addi x11,x11,1 #change seed to change random number generated
    	add x12, x12, x7	# address of charecter at random position
    			
    	 #swap the current character with the character at the random position	

	lb x16, 0(x12)   	# load the character at the random position
	lb x18, 0(x30)   	# load the current character
	sb x18, 0(x12)   	# store the character at the current position
	sb x16, 0(x30)   	# store the current character at the random position
	addi x30,x30,1	#address of charecter at current position    
	addi x14, x14, 1	# increment the loop counter
	blt  x14, x13, loop	#check if counter is less than length
    
li a7,4		# set the print syscall number
la,a0 ,output1	# load the address of the message
ecall     	# execute syscall to print the message


#printing scrambeled text
li a7,4   	# set the print syscall number
la a0,buffer 	# load the address of the message
ecall     	# execute syscall to print the message
    
li a7,4   	# set the print syscall number
la a0,output3 	# load the address of the message
ecall 		# execute syscall to print the message

addi x11,x11,-1 #compute seed for descrambler

li a7,1		# set the print syscall number for integer
mv a0, x11	# load the address of the seed
ecall		# execute syscall to print the message

#######Descrambler#############
li a7,4		# set the print syscall number
la a0,input2	#load the address of the message
ecall     	# execute syscall to print the message

li a7,8		# load the syscall number for reading a string 
la a0,buffer2  	# load the address of the input buffer
li a1,256 	# load max number of characters to read
ecall     	# execute the syscall to read the input string

li a7,4		# set the print syscall number
la a0,input3	#load the address of the message
ecall     	# execute syscall to print the message

li a7,5		# load the syscall number for reading an integer 
la a0,seed  	# load the address of the input buffer
li a1,256 	# load max number of characters to read
ecall     	# execute the syscall to read the input integer
la x11,seed
la x5, buffer2       	# load the address of the input buffer
add x5,x5,x13		#load address of last charecter
li x14, 0 		# initialize the loop counter
neg x25,x13		#to be used for loop condition
##This time loop should work backward

loop2:
	la x6,buffer2		#toad the address of input buffer again to be used to get address of charecter
	remu x7, x11, x13	#generate seeds backward
	addi x11,x11,-1 	#decrement the seed
	add x6,x7,x6		#compute address of charecte at random index
	addi x5,x5,-1		#compute address of current charecter
   	lb x16, 0(x6)   	# load the character at the random position
   	lb x18, 0(x5)   	# load the current character
   	sb x18, 0(x6)   	# store the character at the current position
    	sb x16, 0(x5)   	# store the current character at the random position
    	addi x14, x14, -1	# increment the loop counter
	bgt  x14, x25, loop2	#check if counter is less than length
	
li a7,4		# set the print syscall number
la,a0 ,output2	# load the address of the message
ecall     	# execute syscall to print the message

#printing scrambeled text
li a7,4   	# set the print syscall number
la a0,buffer2 	# load the address of the scrambeled message that is now discrambled
ecall  
