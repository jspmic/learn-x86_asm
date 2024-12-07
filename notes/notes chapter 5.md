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
To call `read`, you need to have the fd in `%ebx`, the address for the buffer(to store what's read) in `%edx`(explained later).
`read` will return the number of characters read or an error code(usually negative). The same goes with `write` except that
the buffer should be filled with the data to write(not empty like `read`).

4. Close the file using `close`(syscall number `6`), with the `fd` in `%ebx`.

## Buffers and .bss
A buffer is a continuous block of bytes used for bulk data transfer.
When you request to read a file, the OS needs to have a place to store the data it reads.
That place is called a buffer. Usually, buffers are used temporarily to store data(it is read and stored into a permanent form).

> Note: Buffers are a fixed size, set by the programmer.
