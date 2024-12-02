.section .data
.section .text
.globl _start
.globl factorial

_start:
	pushl $5  # Push the parameter to the stack
	call factorial  # Call the function `factorial`
	addl $4, %esp  # Scrub the parameter on the stack
	movl %eax, %ebx  # Store the result in %ebx
	movl $1, %eax  # Store the `exit` syscall number in %eax
	int $0x80

.type factorial, @function
factorial:
	pushl %ebp
	movl %esp, %ebp
	movl 8(%ebp), %eax
	cmpl $1, %eax
	je end_factorial
	decl %eax
	pushl %eax
	call factorial
	movl 8(%ebp), %ebx
	imull %ebx, %eax  # Store the result of mull in %eax

end_factorial:
	movl %ebp, %esp
	popl %ebp
	ret
