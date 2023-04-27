# allocate a buffer to store the input string
.data
input: .string "enter the message here:"
output1: .string "Scrambled message: "
buffer: .space 256

.text
main:

####################################################

###########SHOULD SEED BE INPUT???????????
###################################

#######SCRAMBLER#############

# taking input
li a7,4  # load the syscall number for printing a string into a7
la a0, input   # load the address of the message
ecall     # execute syscall to print the message

li a7,8  # load the syscall number for reading a string into a7
la a0,buffer  # load the address of the input buffer
li a1,256   # load max number of characters to read
ecall     # execute the syscall to read the input string

#buffer actual length to be used for random number
la x2, buffer#address of buffer
addi x13,x0,-1#counter to get length, -1 beacuse the buffer extra null terminator
l:
  lbu x1, 0(x2) #load byte
  beqz x1, exit #if byte is null
  addi x13,x13,1 #increment counter
  addi x2,x2,1 #move to next byte
  j l
  exit:
  

#Scrambler key using random number generator
li x11, 1947#load random's seed <---------------------------------SEED
la x12,buffer #load input message to x12
addi x14, x0, 0   # initialize the loop counter

loop:
    #addi x6, x0, 6  # set the upper bound to 2
    remu x7, x11, x13  # generate a random integer less than 2

     #compute the index of the character to swap
    add x15, x14, x7
    rem x15, x15, x13#to make sure I am chosing charecter at position i less than length of message

     #swap the current character with the character at the random position
    add x15,x15,x12 # address of charecter at random position
    add x17,x14,x12#address of charecter at current position
    lb x16, 0(x15)   # load the character at the random position
    lb x18, 0(x17)   # load the current character
    sb x18, 0(x15)   # store the character at the current position
    sb x16, 0(x17)   # store the current character at the random position

    # increment the loop counter
    addi x14, x14, 1
    blt x14, x13, loop
    
li a7,4
la,a0 ,output1
ecall

li a7,4   # set the print syscall number
la a0,buffer 
ecall 
    


#######Descrambler#############





# print the original string
#li a7,4  # load the syscall number for printing a string into a7
#la a0,buffer # YOU MIGHT NOT NEED THE ADDRESS  load the address of the input buffer
#ecall    # execute the syscall to print the input string
