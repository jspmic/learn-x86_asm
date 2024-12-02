ASM = as
LINKER = ld
SRC_DIR=src
BUILD_DIR=build
SRC = factorial
A_ARGS = --32
L_ARGS = -m elf_i386

.PHONY: clean, build, default

default: build
	$(ASM) $(A_ARGS) $(SRC_DIR)/$(SRC).s -o $(BUILD_DIR)/$(SRC).a
	$(LINKER) $(L_ARGS) $(BUILD_DIR)/$(SRC).a -o $(BUILD_DIR)/$(SRC)

build:
	mkdir -p $(BUILD_DIR)

clean:
	rm $(BUILD_DIR)/*
