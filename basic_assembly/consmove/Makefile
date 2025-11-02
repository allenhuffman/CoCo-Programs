# Makefile for Color Computer Console Movement Utility
# Builds both BASIC and DECB versions

# Root name for all files (change this to build different versions)
ROOT_NAME = consmove7

# Assembly source file
ASM_SRC = $(ROOT_NAME).asm

# Disk image for installation
DISK_IMAGE = drive0.dsk

# Output files
BAS_OUT = $(ROOT_NAME).bas
BIN_OUT = $(ROOT_NAME).bin
MAP_BAS = $(ROOT_NAME).map
MAP_BIN = $(ROOT_NAME)_bin.map

# Assembler
ASM = lwasm

# Default target - build both versions
all: basic decb

# Build BASIC version
basic: $(BAS_OUT)

$(BAS_OUT): $(ASM_SRC)
	$(ASM) $(ASM_SRC) -fbasic -o$(BAS_OUT) --map=$(MAP_BAS)

# Build DECB binary version  
decb: $(BIN_OUT)

$(BIN_OUT): $(ASM_SRC)
	$(ASM) $(ASM_SRC) -fdecb -o$(BIN_OUT) --map=$(MAP_BIN)

# Clean up generated files
clean:
	rm -f $(BAS_OUT) $(BIN_OUT) $(MAP_BAS) $(MAP_BIN)

# Install to disk image (requires decb utility)
install: $(BIN_OUT)
	decb copy -2 -r $(BIN_OUT) $(DISK_IMAGE),CONSMOVE.BIN

# Show file sizes and info
info: all
	@echo "=== Build Information ==="
	@echo "Source file: $(ASM_SRC)"
	@if [ -f $(BAS_OUT) ]; then \
		echo "BASIC output: $(BAS_OUT) ($$(wc -c < $(BAS_OUT)) bytes)"; \
	fi
	@if [ -f $(BIN_OUT) ]; then \
		echo "DECB binary: $(BIN_OUT) ($$(wc -c < $(BIN_OUT)) bytes)"; \
	fi
	@if [ -f $(MAP_BAS) ]; then \
		echo "BASIC map file: $(MAP_BAS)"; \
	fi
	@if [ -f $(MAP_BIN) ]; then \
		echo "DECB map file: $(MAP_BIN)"; \
	fi

# Rebuild everything from scratch
rebuild: clean all

# Help target
help:
	@echo "Available targets:"
	@echo "  all      - Build both BASIC and DECB versions (default)"
	@echo "  basic    - Build BASIC version only"
	@echo "  decb     - Build DECB binary version only"
	@echo "  clean    - Remove all generated files"
	@echo "  install  - Copy DECB binary to drive0.dsk (requires decb utility)"
	@echo "  info     - Show build information and file sizes"
	@echo "  rebuild  - Clean and rebuild everything"
	@echo "  help     - Show this help message"

# Declare phony targets
.PHONY: all basic decb clean install info rebuild help