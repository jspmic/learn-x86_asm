.section .data
.section .text
.globl _start
.globl square

_start:
	pushl $6
	call square
	movl $1, %eax
	int $0x80

.type square, @function
square:
	pushl %ebp
	movl %esp, %ebp
	movl 8(%ebp), %ebx
	imull %ebx, %ebx
	jmp end_square

end_square:
	movl %ebp, %esp
	popl %ebp
	ret
