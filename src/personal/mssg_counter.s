#	PURPOSE: This program is an implementation of a function
#			 that prints a given string N times to STDOUT.

.section .data
	mssg:
		.asciz "\n\tHello World"
	mssg_end:
		.equ LEN, mssg_end - mssg
	mssg2:
		.asciz "\n\tExiting...."
	mssg_end2:
		.equ LEN2, mssg_end2 - mssg2


	.equ STDOUT, 1
	.equ N, 10
	.equ EXIT_SUCCESS, 0

	.equ SYS_EXIT, 1
	.equ SYS_WRITE, 4
	.equ SYSCALL, 0x80

.section .text
.global _start

_start:
	pushl $N
	pushl $mssg
	pushl $LEN
	call printf  # Printing the first string `mssg`

.type printf, @function
printf:
	pushl %ebp
	movl %esp, %ebp
	movl 8(%ebp), %edx # Contains the string length
	movl 12(%ebp), %ecx # Contains the first letter
	movl 16(%ebp), %edi # Contains the counter
	movl $STDOUT, %ebx # Prints on screen
	movl $SYS_WRITE, %eax
	int $SYSCALL
	cmpl $1, %edi
	je _print_exit
	decl %edi
	pushl %edi
	pushl %ecx
	pushl %edx
	call printf
	jmp _exit

_print_exit:
	movl %ebp, %esp
	popl %ebx
	ret

_exit:
	movl $EXIT_SUCCESS, %ebx
	movl $SYS_EXIT, %eax
	int $SYSCALL
