ASM = as
LINKER = ld

# Uncomment/Comment the following line to build(or not) examples from the book
# SRC_DIR=src

# Uncomment/Comment the following line to build(or not) my personal programs
SRC_DIR=src/personal

BUILD_DIR=build
A_ARGS = --32
L_ARGS = -m elf_i386

# Uncomment/Comment the following line to build(or not) examples from the book
# FILES = exit factorial file maximum power square

# Uncomment/Comment the following line to build(or not) my personal programs
FILES = mssg_counter printf

all: $(addprefix $(BUILD_DIR)/,$(FILES))

$(BUILD_DIR)/%: $(SRC_DIR)/%.s
	@mkdir -p $(BUILD_DIR)
	$(ASM) $(A_ARGS) $< -o $@.a
	$(LINKER) $(L_ARGS) $@.a -o $@
	@rm $@.a

clean:
	@rm $(BUILD_DIR)/*

.PHONY: clean, all
