# Chapter 2: Computer Architecture
---

## The CPU
---
The CPU reads in instructions from memory one at a time and executes them.
This is called the `fetch-execute cycle`.
The CPU contains the following elements to do this:
- Program Counter
- Instruction Decoder
- Data bus
- General-purpose registers
- Arithmetic and logic unit

The `program counter` is used to tell the computer where to fetch the next instruction from.
The CPU begins by looking at the program counter and fetching whatever
number is stored in memory at the location specified.

It is passed on to the `instruction decoder` which figures out what the
instruction means. This includes what process needs to take place(addition,
substraction, multiplication, data movement, etc.) and what memory
locations are going to be involved in this process. Computer instructions
consist of both the actual instruction and the list of memory locations
that are used to carry it out.

Now, the computer uses the `data bus` to fetch the memory locations to be
used in the calculation. The data bus is the connection between the
CPU and memory. It is the actual wire that connects them. On the mobo,
the wires that go out from the memory are your data bus.

In addition to the memory on the outside of the processor, the processor
itself has some special, high-speed memory locations called `registers`.
There are 2 kind of registers:
- General registers
- Special-purpose registers

`General purpose registers` are where the main action happens.
Addition, subtraction, multiplication, comparisons, and other operations
use general-purpose registers for processing. However, there are not so
many registers in computers.
Most information is stored in main memory, brought in to the registers
for processing, and then put back into memory when the processing
is completed.

`Special-purpose registers` are registers which have very specific purposes.

After the CPU has retrieved all the data needed, it passes on the data and
the decoded instruction to the `ALU`(Arithmetic and Logic Unit) for further
processing.
Here the instruction is executed. After the result of the computation,
the results of the computation have been calculated, the results are then
placed on the data bus and sent to the appropriate location in memory or
in a register, as specified by the instruction.


## Vocabulary
---
- The size of a typical register is called a computer's `word` size.
On a typical computer, 1 word = 4 bytes.
Processors can access up to 2**(8*4) = 4294967296 bytes

- Addresses which are stored in memory are called `pointers`. They point you to a different location in memory.

Computer instructions are also stored the same way as other data.
The only way the computer knows that a memory location is an instruction is
that a special-purpose register called the instruction pointer points to them
at one point or another. If the instruction pointer points to a memory word,
it is loaded as an instruction.
Other than that, the computer can't tell the difference between programs and
other types of data.

## Data Accessing Methods
---
Processors have a number of different ways of accessing data(or addressing modes)

- Immediate mode
- Register addressing mode
- Direct addressing mode
- Index addressing mode
- Indirect addressing mode
- Base pointer addressing mode

In the `immediate mode`, data access is embedded in the instruction itself.
Ex: If we want to initialize a register to 0, instead of giving the computer
an address to read the 0 from, we would specify immediate mode, and give it
the number 0.

In the `register addressing mode`, the instruction contains
a register to access, rather than a memory location.

In the `direct addressing mode`, the instruction contains the memory address
to access.
Ex: I could say, please load this register with the data at address 2002.
The computer would go directly to byte number 2002 and copy the contents into
our register.

In the `indexed addressing mode`, the instruction contains a memory address to access,
and also specifies an index register to offset that address.
Ex: We could specify address 2002 and an index register. If the index register
contains the number 4, the actual address the data is loaded from would be
2006. This is used in arrays in many languages.

In the `indirect addressing mode`, the instruction contains a register that
contains a pointer to where the data should be accessed.
Ex: If we used indirect addressing mode and specified the `%eax` register
contained the value 4, whatever value was at memory location 4 would be used.

The `base pointer addressing mode` is similar to indirect addressing mode,
but you also include a number called the `offset` to add to the
register's value before using it for lookup.
