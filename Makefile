ASM = as
LINKER = ld
SRC = factorial.s
A_ARGS = --32
L_ARGS = -m elf_i386
OBJ = a.out
BIN = out

default:
	$(ASM) $(A_ARGS) $(SRC)
	$(LINKER) $(L_ARGS) $(OBJ) -o $(BIN)

clean:
	rm $(BIN) $(OBJ)
