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
 
### Function Calls
In the C calling convention, the stack is the key element for implementing a function's local variables, parameters and
return address.

Before executing a function:
- The program pushes all of the parameters onto the stack in the reverse order
- The program issues a `call` instruction indicating which function it wishes to start.

The `call` instruction does 2 things:
- Push the address of the next instruction(return address) onto the stack
- Modify the instruction pointer(`%eip`) to point to the start of the function

    ┌─────────────────┐
    │  Parameter n    │
    │    ...          │
    │  Parameter 2    │
    │  Parameter 1    │
    │  Return address │
    │                 │
    └─────────────────┘

The function has some work to do:
- Save the current base pointer register, `%ebp`, by doing `pushl %ebp`.

> The base pointer is a special register used to access the function parameters and local variables.

- Copy the stack pointer to `%ebp` by `movl %esp, %ebp`. This allows to access the function parameters as fixed
indexes from the base pointer.

> Copying the stack pointer into the base pointer at the beginning of a function allows you to always know where
 your parameters are, even while you may be pushing things on and off the stack.
 `%ebp` will always be where the stack pointer was at the beginning of the function, it is more or less a constant
 reference to the `stack frame`(the stack frame consists of all the stack variables used within a function, including
 parameters, local variables, and the return address).

 At this point, the stack looks like this:

       ┌────────────────┐
       │ Parameter n    │  <-- N*4+4(%ebp)
       │    ...         │
       │ Parameter 2    │  <-- 12(%ebp)
       │ Parameter 1    │  <-- 8(%ebp)
       │ Return address │  <-- 4(%ebp)
       │ Old %ebp       │  <-- (%ebp) and (%esp)
       └────────────────┘

Each parameter can be accessed using the base pointer addressing mode using the `%ebp` register.

Next, the function reserves space on the stack for any local variables it needs. This is done by
moving the stack pointer out of the way.
Ex: We may need 2 words to run a function, we can simply move the stack pointer down 2 words to
reserve the space: `subl $8, %esp`, this subtracts 8 from `%esp`. Since it is allocated on the stack
frame for this function call, the variable will only be alive during this function.

Our stack now looks like this:

      ┌──────────────────┐
      │ Parameter n      │  <-- N*4+4(%ebp)
      │   ...            │
      │ Parameter 2      │  <-- 12(%ebp)
      │ Parameter 1      │  <-- 8(%ebp)
      │ Return address   │  <-- 4(%ebp)
      │ Old %ebp         │  <-- (%ebp)
      │ Local variable 1 │  <-- -4(%ebp)
      │ Local variable 2 │  <-- -8(%ebp) and (%esp)
      └──────────────────┘

We can now access all of the data we need for this function by using the base pointer addressing mode
using different offsets from %ebp. `%ebp` was made specifically for this purpose, which is why it is
called the `base pointer`.

> Other registers in base pointer addressing mode can be used, but x86 makes using the `%ebp` register a lot faster.

When a function is done executing, it does 3 things:
- It stores its return value in `%eax`
- Resets the stack to what it was when it was called.

To return from the function we have to do the following:
```asm
movl %ebp, %esp
popl %ebp
ret
```











































