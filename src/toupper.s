.section .data

.equ SYS_OPEN, 5
.equ SYS_WRITE, 4
.equ SYS_READ, 3
.equ SYS_CLOSE, 6
.equ SYS_EXIT, 1
.equ LINUX_SYSCALL, 0x80

.equ STDIN, 0
.equ STDOUT, 1
.equ STDERR, 2

.equ O_RDONLY, 0
.equ O_CREAT_WRONLY_TRUNC, 03101

.equ EOF, 0
.equ NO_ARGS, 2

.section .bss
	.equ BUFFER_SIZE, 500
	.lcomm BUFFER_DATA, BUFFER_SIZE

.section .text

.equ ST_SIZE_RESERVE, 8
.equ ST_FD_IN, -4
.equ ST_FD_OUT, -8
.equ ST_ARGC, 0 	# Number of arguments
.equ ST_ARGV_0, 4 	# Name of program
.equ ST_ARGV_1, 8 	# Input file name
.equ ST_ARGV_2, 12	# Output file name

.globl _start
_start:
	movl %esp, %ebp
	subl $ST_SIZE_RESERVE, %esp

open_files:
open_fd_in:
	###	OPEN INPUT FILE
	movl $SYS_OPEN, %eax
	movl ST_ARGV_1(%ebp), %ebx
	#	read-only flag
	movl $O_RDONLY, %ecx
	#	this doesn’t really matter for reading
	movl $0666, %edx
	int $LINUX_SYSCALL

store_fd_in:
	#	save the given file descriptor
	movl %eax, ST_FD_IN(%ebp)

open_fd_out:
	###	OPEN OUTPUT FILE
	movl $SYS_OPEN, %eax
	movl ST_ARGV_2(%ebp), %ebx
	movl $O_CREAT_WRONLY_TRUNC, %ecx
	#	mode for new file (if it’s created)
	movl $0666, %edx
	int $LINUX_SYSCALL

store_fd_out:
	#	store the file descriptor here
	movl %eax, ST_FD_OUT(%ebp)

###BEGIN MAIN LOOP###

read_loop_begin:
	###	READ IN A BLOCK FROM THE INPUT FILE###

	movl $SYS_READ, %eax
	movl ST_FD_IN(%ebp), %ebx
	movl $BUFFER_DATA, %ecx
	movl $BUFFER_SIZE, %edx
	int $LINUX_SYSCALL

	###	EXIT IF WE’VE REACHED THE END
	cmpl $EOF, %eax

	#	if EOF found or on error, go to the end
	jle end_loop

continue_read_loop:
	###	CONVERT THE BLOCK TO UPPER CASE
	pushl $BUFFER_DATA		# Location of buffer
	pushl %eax				# Size of the buffer(number of characters read)
	call convert_to_upper
	popl %eax				# Get the size back
	addl $4, %esp			# Restore %esp

	###	WRITE THE BLOCK OUT TO THE OUTPUT FILE
	movl %eax, %edx
	movl $SYS_WRITE, %eax
	movl ST_FD_OUT(%ebp), %ebx
	movl $BUFFER_DATA, %ecx
	int $LINUX_SYSCALL

	###CONTINUE THE LOOP###
	jmp read_loop_begin

end_loop:
	###CLOSE THE FILES###
	# 	NOTE - we don’t need to do error checking
	# 	on these, because error conditions
	#	don’t signify anything special here

	movl $SYS_CLOSE, %eax
	movl ST_FD_OUT(%ebp), %ebx
	int $LINUX_SYSCALL
	movl $SYS_CLOSE, %eax
	movl ST_FD_IN(%ebp), %ebx
	int $LINUX_SYSCALL

	###EXIT###
	movl $SYS_EXIT, %eax
	movl $0, %ebx
	int $LINUX_SYSCALL

#The lower boundary of our search
.equ LOWERCASE_A, 'a'

#The upper boundary of our search
.equ LOWERCASE_Z, 'z'

#Conversion between upper and lower case
.equ UPPER_CONVERSION, 'A' - 'a'

###STACK STUFF###
.equ ST_BUFFER_LEN, 8	# Length of buffer(number of characters read)
.equ ST_BUFFER, 12		# actual buffer

.type convert_to_upper, @function
convert_to_upper:
	pushl %ebp
	movl %esp, %ebp
	movl ST_BUFFER(%ebp), %eax
	movl ST_BUFFER_LEN(%ebp), %ebx
	movl $0, %edi
	cmpl $0, %ebx		# Not necessary since we checked for the EOF up there
	je end_convert_loop

convert_loop:
	movb (%eax,%edi,1), %ch
	cmpb $LOWERCASE_A, %ch
	jl next_byte
	cmpb $LOWERCASE_Z, %ch
	jg next_byte
	addb $UPPER_CONVERSION, %ch
	movb %ch, (%eax,%edi,1)

next_byte:
	incl %edi
	cmpl %edi, %ebx
	jne convert_loop

end_convert_loop:
	movl %ebp, %esp
	popl %ebp
	ret
