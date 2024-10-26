# Chapter 4: All About Functions
---
We use functions to break the program into pieces.
The data items the function is given to process are called `parameters`.
The function's interface are its parameters list and its processing expectations.
In assembly language, the primitive functions are similar to system calls, although
those syscalls aren't "really" functions.

## How functions work
Functions are composed of:
- a function name
- function parameters
Ex: `sin(2)`, `sin` is the name and `2` the parameter.
- local variables
- static variables
- global variables
- return address
The return address is a parameter which tells the function where to resume after executing the function.
- return value
The return value is the main method to transfer data back to the main program.

A language `calling convention` is the way that the variables are stored and the parameters and return
values are transferred by the computer varies from language to language.
Assembly language can use any calling convention, you can even make one!
We will use the C programming language calling convention since it is widely used.

## Assembly-language Functions using the C Calling Convention
Let's first understand how the computer's stack works:

Each computer program that run uses a region of memory called the `stack` to enable functions to work
properly. It follows the LIFO principle(Last In First Out).
The computer's stack lives at the top addresses of memory. You can push values onto the top of the
stack through an instruction called `pushl`, which pushes either a register or memory value onto
the top of the stack. In reality it's the "bottom" of the stack not the "top".
The reason for this is that the stack grows downward in memory due to architectural considerations.
You can also pop values off the top of the stack through the instruction `popl`.
This removes the value from the top of the stack and places it into a register of your choice.

We can actually continually push values onto the stack and it will keep growing further and further down in memory
until we hit our code or data. So how do we know where the current "top" of the stack is? The stack register,
`%esp`, always contains a pointer to the current top of the stack, wherever it is.

Every time we `pushl` onto the stack, `%esp` is decreased by a word.
And when we use `popl`, `%esp` is increased by a word and stores the popped value into a register of choice.
`pushl` and `popl` take one operand:
- `pushl`: the register to push onto the stack
- `popl`: the register to receive data that is popped off the stack

> Tip: If we want to get the value at the address %eax, we can use indirect addressing mode `(%eax)`,
 If we want to access the value right below the top of the stack we can use the base addressing mode: `4(%eax)`.



























































