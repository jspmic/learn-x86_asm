# Chapter 3: First Programs
---
```exit.s
.section .data

.section .text
.globl _start
_start:
	movl $1, %eax
	movl $1, %ebx
	int $0x80
```

On most instructions which have two operands(like movl), the first one is the
source operand and the second one is the destination.
In the case with `movl`, the source operand is not modified at all.
Other instructions of this type are, for example `addl`, `subl` and `imull`.

These `add/subtract/multiply ` `<the source operand>` `from/to/by`
the `<destination operand>`.

Other instructions may have an operand hardcoded in.
`idivl`, for instance, requires that the dividend be in `%eax`, and
`%edx` be zero, and the quotient is then transferred to `%eax` and the
remainder to `%edx`. The divisor can be any register or memory location.

on x86 processors, there are several general-purpose registers(can be used with
`movl`):
- %eax
- %ebx
- %ecx
- %edx
- %edi
- %esi

In addition to those, there are several special-purpose registers:
- %ebp
- %esp
- %eip
- %eflags


Some of these special-purpose registers like `%eip` and `%eflags` can only
be accessed through special instructions. The rest can be accessed using the
same instructions as general-purpose registers, but they have
special meanings, special uses, or simply faster when used in a specific way.


The `movl` instruction moves the number `1` into `%eax`. The `$` sign in front
of the one indicates that we want to use immediate mode addressing.
Without the `$` sign, it would do direct addressing, loading the number
at address `1`.

The number `1` is the number of the `exit` system call. We shall discuss
this in depth later.

Normal programs can't do everything. Many operations such as calling other
programs, dealing with files, and exiting have to be handled by the operating
system through system calls.
When you make a system call, the system call number has to be loaded
into `%eax`. Depending on the system call, other registers may have to have
values in them as well.
Note that system calls are not the only use or even the main use of registers.
It is just one we are dealing with in this first program(`exit.s`).
When dealing with files, the operating may need to know which file, what
data you wanna write, and other details. The extra details are called
`parameters` and are stored in other registers.
In the case of the `exit` system call, the operating system requires a
status code to be loaded in `%ebx`. This value is returned to the system.
This is the value retrieved after `echo $?`.
So we load `%ebx` with 0 by: `movl $0, %ebx`.

Simply Loading these values doesn't do a thing, but it is required to make
the `exit` system call.

The next instruction is the "magic" one: `int $0x80`.
The `int` stands for interrupt. The `0x80` is the interrupt number to use.
An `interrupt` interrupts the normal program flow, and transfers control
from our program to Linux so that it will do a system call.
In fact, it transfers control to whoever set up an interrupt handler for the
interrupt number. In the case of Linux, all of them are set to be handled by
the Linux kernel.

If we didn't signal the interrupt, then no system call would have been performed.

>Quick System Call Review: To recap - Operating System features are
accessed through system calls. These are invoked by setting up the
registers in a special way and issuing the instruction int $0x80. Linux
knows which system call we want to access by what we stored in the
%eax register. Each system call has other requirements as to what needs to
be stored in the other registers. System call number 1 is the exit system
call, which requires the status code to be placed in %ebx.

## Program to find the maximum number in a list
---
- `%edi` will hold the current position in the list
- `%ebx` will hold the current highest value in the list
- `%eax` will hold the current element being examined

We will start counting from 0. The last element will be imperatively 0.

```Algorithm
1. Check the current list element (%eax) to see if it’s zero (the terminating
element).
2. If it is zero, exit.
3. Increase the current position (%edi).
4. Load the next value in the list into the current value register (%eax). What
addressing mode might we use here? Why?
5. Compare the current value (%eax) with the current highest value (%ebx).
6. If the current value is greater than the current highest value, replace the current highest value with the current value.
7. Repeat.
```

These "if"s are a class of instructions called flow control instructions, because they
tell the compute which steps to follow and which paths to take.
Depending on what data it receives, it will follow different instruction paths.

In this program, this will be accomplished by two different instructions, the
conditional jump and the unconditional jump.
The conditional jump changes paths based on the results of a previous
comparison or calculation.
The unconditional jump just goes directly to a different path no matter what.

Solution in `maximum.s`.

In the program we have something in the data section.
```
data_items:
    .long ...
```
data_items is a label that refers to the location that follows it.
There is a directive that starts with `.long`. The assembler reserves
memory for the list of numbers that follow it. `data_items` refers to the
location of the first one(number). Because data_items is a label,
any time in our program where we need to refer to this address
we can use the data_items symbol, and the assembler will substitute it 
with the address where the numbers start during assembly.

There are different types of memory locations other than `.long`:
- `.byte`: Bytes take up one storage location for each number. 0-255
- `.int`: Ints take up 2 storage locations. 0-65535
- `.long`: takes up 4 storage locations: 0-(2**32)
- `.ascii`: To enter characters into memory. 1 storage location.
ex: "Hello there\0" would reserve 12 storage locations(bytes).

There are many jump statements:
- `je`: Jump if the values are equal
- `jg`: Jump if the second value is greater than the first value
- `jge`: `jg` or `je`
- `jl`: Jump if the second value was less than the first value
- `jle`: `jl` or `je`
- `jmp`: Jump no matter what.

## Addressing modes
---
We will see how the addressing modes seen in chapter 2 are represented
in the assembly language.

The general form of memory address is this:
`ADDRESS_OR_OFFSET(%BASE_OR_OFFSET,%INDEX,MULTIPLIER)`
All the fields are optional. If any field is left empty, it is considered being 0.

- Direct addressing mode
Only uses the `ADDRESS_OR_OFFSET` field
Ex: `movl ADDRESS, %eax`, which means load the value at `ADDRESS`
into `eax`.

- Indexed addressing mode
This is done by using the `ADDRESS_OR_OFFSET` and the `%INDEX` portion.
You can use any general-purpose register in the `%INDEX` portion.
You can also have a constant multiplier of 1, 2, or 4 for the index register,
to make it easier to index by bytes, double-bytes, and words.
Ex: `movl string_start(,%ecx,1), %eax`, this starts at `string_start` and
adds `1 * %ecx` to that address and loads it into `%eax`.

- Indirect addressing mode
It loads a value from the address indicated by a register.
Ex: `movl (%eax), %ebx`, we move the address in `eax` into `ebx`.

- Base pointer addressing mode
Similar to indirect addressing mode except that it adds a constant value
to the address.
Ex: `movl 4(%eax), %ebx` load the value at `4+%eax` into `%ebx`

- Immediate mode
It is used to load direct values into registers or memory locations.
Ex: `movl $13, %ecx`, loads `13` into `%ecx`.

In addition to these modes, there are also different instructions for different sizes
of values to move. For example, we have been using `movl` to move data a word at
a time. in many cases, you will only want to move data a byte at a time. This is
accomplished by the instruction `movb`. However, since the registers we have
discussed are word-sized and not byte-sized, you cannot use the full register.
Instead, you have to use a portion of the register.

Let's take an example of `eax`(which is word-sized):
- If i wanted to work with 2 bytes, i would use `ax`(the LSB of `eax`),
- `ax` is divided into `al`(the LSB of `ax`) and `ah`(the MSB of `ax`)

Loading a value in `eax` will wipe out everything in `al`, `ah` and `ax`.
Similarly, loading a value in either `al` or `ah` will corrupt `eax`.
Never use the same register for a byte and a word at the same time.
































