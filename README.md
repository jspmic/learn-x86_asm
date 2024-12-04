# Learn x86 Assembly
This repository contains my notes and programs as I explore x86 assembly language, guided by the book <i>Programming from the Ground Up</i> by Jonathan Bartlett.

# Description
Assembly language is a key to understanding how computers work at the hardware level. This repository serves as a record of my learning journey, with:
- Notes: summarizing concepts and examples of each chapter from the book.
- Programs: written from exercises in the book.
- Personal programs: I wrote to deepen my understanding of x86 assembly concepts.

# Structure
The repository is organized as follows:
- `notes/`: Contains detailed notes and explanations from <i>Programming from the Ground Up</i>.
- `src/`: Assembly programs written as exercises or examples from the book.
- `src/personnal`: Programs I created to experiment with and reinforce the concepts.

# Prerequisites
To run the programs in this repository, you'll need:
- GNU Assembler (`as`): Install via your package manager (e.g., `sudo pacman -S binutils` for Arch Linux).
- Linker (`ld`): Part of the GNU Binutils package.

# Usage
1. Clone the repo:<br />`git clone https://github.com/jspmic/learn-x86_asm.git`<br />`cd learn-x86_asm`
2. Build the project: `make`
3. Run the program(e.g `./build/factorial`)

# Resources
- <a href="https://www.amazon.com/Programming-Ground-Up-Jonathan-Bartlett/dp/1616100648">Programming From The Ground Up</a> by Jonathan Bartlett (used as a primary reference).
- Additional research and experimentation for personal programs.
# Why Learn Assembly?
Understanding assembly provides insights into:
- How high-level languages interact with hardware.
- Optimization techniques for low-level systems.
- The inner workings of compilers and operating systems.

# Contributing
While this repository is primarily for personal learning, feel free to:
- Submit suggestions or corrections via pull requests.
- Open issues to discuss assembly concepts.

# License
This repository is licensed under the MIT License.
