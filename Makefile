ASSEMBLER="as"
LINK="ld"
FILE="maximum.s"
ARGS="-o"
OBJ="a.out"
BIN="out"

default:
	$(ASSEMBLER) $(FILE) $(ARGS) $(OBJ)
	$(LINK) $(OBJ) $(ARGS) $(BIN)

clean:
	rm $(BIN) $(OBJ)
