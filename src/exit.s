# Anything that starts with a period is an assembler directive
# Or pseudo-operations
.section .data
# The data section is where you list any memory storage you need for data

.section .text
# The text section is where the program instructions live
.globl _start
# This instructs the assembler that _start is important to remember

# _start is a symbol, it will be replaced by something else during assembly or
# linking

# Symbols are used to mark locations of programs or data,
# So you can refer to them by name instead of by their location number.

# .globl means that the assembler shouldn't discard this symbol after assembly,
# because the linker will need it.
# _start is a special symbol that always needs to be marked with .globl
# because it marks the location of the start of the program.

# Without marking this location, the computer won't know where to begin

_start:
	# Defines the value of the _start label
	# A label is a symbol followed by a colon
	movl $1, %eax
	movl $3, %ebx
	int $0x80
