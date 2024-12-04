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
.equ EOF, 0

.equ BUFFER_SIZE, 500

.section .bss
	.lcomm buffer, BUFFER_SIZE

.section .text

.globl _start

_start:
	movl $STDIN, %ebx
	movl $buffer, %ecx
	movl $BUFFER_SIZE, %edx
	movl $SYS_EXIT, %eax
	int $LINUX_SYSCALL
