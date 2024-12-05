# PURPOSE:   This program is an implementation of a function
#			 that prints a given string to STDOUT.
#			 This small program consists of 2 strings examples

.section .data
	mssg:
		.ascii "\n\tHello World!\0"
	mssg2:
		.ascii "\n\tSuccess...\0"

	.equ LEN, 14
	.equ LEN2, 13

	.equ STDOUT, 1

	.equ SYS_EXIT, 1
	.equ SYS_WRITE, 4
	.equ SYSCALL, 0x80

.section .text
.global _start

_start:
	pushl $mssg
	pushl $LEN
	call printf  # Printing the first string `mssg`

	movl $4, %eax  # Scrubbing

	pushl $mssg2
	pushl $LEN2
	call printf  # Printing the 2nd string `mssg2`

	jmp _exit # Exit the program

.type printf, @function
printf:
	pushl %ebp
	movl %esp, %ebp
	movl 8(%ebp), %edx # Contains the string length
	movl 12(%ebp), %ecx # Contains the first letter
	movl $STDOUT, %ebx # Prints on screen
	movl $SYS_WRITE, %eax
	int $SYSCALL
	jmp _print_exit

_print_exit:
	movl %ebp, %esp
	popl %ebx
	ret

_exit:
	movl $0, %ebx  # Exit successfully
	movl $SYS_EXIT, %eax
	int $SYSCALL
