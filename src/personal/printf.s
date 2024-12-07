# PURPOSE:   This program is an implementation of a function
#			 that prints a given string to STDOUT.
#			 This small program consists of 2 strings examples

.section .data
	mssg:
		.asciz "\n\tHello World"
	mssg_end:
		.equ LEN, mssg_end - mssg
	mssg2:
		.asciz "\n\tSuccess...."
	mssg_end2:
		.equ LEN2, mssg_end2 - mssg2

	.equ LEN, 14

	.equ STDOUT, 1
	.equ EXIT_SUCCESS, 0

	.equ SYS_EXIT, 1
	.equ SYS_WRITE, 4
	.equ SYSCALL, 0x80

.section .text
.global _start

_start:
	pushl $mssg
	pushl $LEN
	call printf  # Printing the first string `mssg`

	addl $8, %esp  # Scrubbing the parameters

	pushl $mssg2
	pushl $LEN2
	call printf  # Printing the 2nd string `mssg2`

	jmp _exit # Exit the program


# @description: This function prints the given message(of length N) to STDOUT
# @args: The string and its length
# @returns: Nothing particular(except the status returned by the SYSCALL in %eax)
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

# This label is jumped to when the program is to be closed
_exit:
	movl $EXIT_SUCCESS, %ebx  # Exit successfully
	movl $SYS_EXIT, %eax
	int $SYSCALL
