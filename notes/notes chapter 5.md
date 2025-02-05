# Dealing with files
Data which is stored in files is called persistent data,
because it persists in files that remain on the disk even when the program isn’t running(except temporary files).

## The UNIX File Concept
The UNIX method of dealing with files is far the simplest one. The UNIX files can be accessed as a sequential stream
of bytes. Here's the process of dealing with files:

1. You open a file by giving its name
2. The OS gives you a number, called a `file descriptor`(fd), which is used to refer to the file
3. Write/read to/into the file using the `file descriptor`
4. Close the file which makes the fd useless

We will deal with files in this way when writing our asm programs:
1. Tell Linux the name of the file to open and in what mode you want it(read, write, read&write, ...).
We will use the `open` syscall which takes a `filename`, a number representing the `mode`, and a `permission`
`%eax` will hold the `syscall` number which is `5`, the address of the first character of the `filename` into `%ebx`,
The `mode` number into `%ecx`, the permission set as a number into `%edx`.
> Tip: use 0666(with the leading zero) for the permissions if you're unfamiliar with them

2. the OS will return the `fd` in `%eax`

3. Operate on the file using the `fd`. For read use `read`(syscall number `3`); for write use `write`(syscall number `4`).
To call `read`, you need to have the fd in `%ebx`, the address for the buffer(to store what's read) in `%ecx`(explained later)
and the size of the buffer in `%edx`.
`read` will return the number of characters read or an error code(usually negative). The same goes with `write` except that
the buffer should be filled with the data to write(not empty like `read`).

4. Close the file using `close`(syscall number `6`), with the `fd` in `%ebx`.

## Buffers and .bss
A buffer is a continuous block of bytes used for bulk data transfer.
When you request to read a file, the OS needs to have a place to store the data it reads.
That place is called a buffer. Usually, buffers are used temporarily to store data(it is read and stored into a permanent form).

> Note: Buffers are a fixed size, set by the programmer.

If you want to read in data 500 bytes at a time, you send the read system call the address of a 500-byte unused location,
and send it the number 500 so it knows how big it is.

To create a buffer, you need to either reserve static or dynamic storage:
- Static storage are storage locations declared using `.long` or `.byte` directive.
- Dynamic storage will be elaborated in later chapters

Declaring buffers using static storage presents problems:
- You would have to type 500 numbers after the `.byte` directive and it would be tedious to type them
- It would take unnecessary memory in the executable

In short, if you want 500 bytes you would have to type 500 numbers and consume 500 bytes in the executable.

There is a solution to this, but let's introduce a new section in our program. Apart from the `.text` and `.data` section,
there is another section called `.bss`.

This section ressembles a lot to `.data` except that it doesn't take up space in the executable. It can reserve storage,
but it can't initialize it. In the `.data` section you could set initial values, but in `.bss` you cant'.
We will use this section to declare buffers(since buffers are storages that need to be reserved not initialized).

To achieve this we have to do:

```asm
.section .bss
    .lcomm my_buffer, 500
```

> `.lcomm` will create a symbol `my_buffer` that will refer to a 500 bytes location.

When accessing `my_buffer`, we need to use immediate addressing mode:

```asm
movl $my_buffer, %ecx  # Not movl my_buffer, %ecx
```


## Standard and Special Files
The program starts with some default files opened(for Linux we have at least 3), namely:
- STDIN: The `Standard Input` which refers to the keyboard(it is read-only). `fd=0`
- STDOUT: The `Standard Output` which refers to the screen display(it is write-only). `fd=1`
- STDERR: The `Standard Error` which refers to the screen display(it is write-only). `fd=2`

These files can be redirected from or to a real file, rather than the screen or the keyboard.

> Use the `.equ` directive to name a constant in your program, ex: `.equ SYSCALL 0x80` which means SYSCALL -> 0x80
 You can then call `int $SYSCALL` to substitute it to `int $0x80`






