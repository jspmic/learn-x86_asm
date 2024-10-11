ASSEMBLER="as"
LINKER="ld"
FILE="stack.s"
ARGS="-o"
OBJ="a.out"
BIN="out"

default:
	$(ASSEMBLER) $(FILE) $(ARGS) $(OBJ)
	$(LINKER) $(OBJ) $(ARGS) $(BIN)

clean:
	rm $(BIN) $(OBJ)
