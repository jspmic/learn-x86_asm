#VARIABLES: The registers have the following uses:
#
# %edi - Holds the index of the data item being examined
# %ebx - Largest data item found
# %eax - Current data item
#
# The following memory locations are used:
#
# data_items - contains the item data. A `0` is used
#			   to terminate the data

.section .data
data_items:
	# a long uses 4 bytes in memory
	.long 3, 67, 34, 100, 45, 0, 54, 34, 44, 33, 22, 11, 66, 255

.section .text
.globl _start
_start:
	movl $0, %edi # move 0 into the index register
	# data_items is the location number of the start of our number list
	movl data_items(, %edi, 4), %eax # load the first byte of data
	movl %eax, %ebx # The first item in %eax will be the biggest in %ebx

start_loop: # start loop
	cmpl $255, %eax # check to see if we've hit the end
	je loop_exit
	incl %edi # load next value
	movl data_items(, %edi, 4), %eax
	cmpl $255, %eax # check to see if we've hit the end
	je loop_exit
	cmpl %ebx, %eax # Compare values
	jle start_loop # jump to loop beginning if the new one isn't bigger
	movl %eax, %ebx # move the value as the largest
	jmp start_loop

loop_exit:
	# %ebx is the status code for the exit system call
	movl $1, %eax # 1 is the exit() syscall
	int $0x80
