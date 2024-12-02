.section .data

.section .text

.globl _start

_start:
	# We will write the power function that takes 2 arguments:
	# The number n and the power p to raise it to(n ^ p)
	# We will only allow values of p such as p>=1

	# Let's first calculate 2^3 + 5^2
	pushl $3
	pushl $2
	call power # call the function
	addl $8, %esp
	pushl %eax
	pushl $2
	pushl $5
	call power
	addl $8, %esp
	popl %ebx
	addl %eax, %ebx
	movl $1, %eax
	int $0x80

.type power, @function
power:
	pushl %ebp
	movl %esp, %ebp
	subl $4, %esp # Reserves the space to store the result
	
	movl 8(%ebp), %ebx # The base is moved into ebx
	movl 12(%ebp), %ecx # The power is moved into ecx
	movl %ebx, -4(%ebp) # Move what's into ebx into the result-reserved space

power_loop_start:
	cmpl $1, %ecx
	je end_power
	movl -4(%ebp), %eax # Move the result into eax
	imull %ebx, %eax # Multiply the base with the result and store it in eax
	movl %eax, -4(%ebp) # Move the result into the result-reserved space
	decl %ecx # Decrement ecx(which is the register containing the power)
	jmp power_loop_start

end_power:
	movl -4(%ebp), %eax # Move the final result in eax
	movl %ebp, %esp
	popl %ebp
	ret
