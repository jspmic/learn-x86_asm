ASM = as
LINKER = ld
SRC = maximum.s
ARGS = -o
OBJ = a.out
BIN = out

default:
	$(ASM) $(SRC) $(ARGS) $(OBJ)
	$(LINKER) $(OBJ) $(ARGS) $(BIN)

clean:
	rm $(BIN) $(OBJ)
