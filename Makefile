ASM = as
LINKER = ld
# SRC_DIR=src
SRC_DIR=src/personal
BUILD_DIR=build
A_ARGS = --32
L_ARGS = -m elf_i386

# FILES = exit factorial file maximum power square
FILES = mssg_counter printf

all: $(addprefix $(BUILD_DIR)/,$(FILES))

$(BUILD_DIR)/%: $(SRC_DIR)/%.s
	@mkdir -p $(BUILD_DIR)
	$(ASM) $(A_ARGS) $< -o $@.a
	$(LINKER) $(L_ARGS) $@.a -o $@
	@rm $@.a

clean:
	rm $(BUILD_DIR)/*

.PHONY: clean, all
