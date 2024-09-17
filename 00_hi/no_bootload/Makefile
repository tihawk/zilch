
# Variables
ASM = nasm
ASM_FLAGS = -f bin
OD = od
OD_FLAGS = -A n -t o1
BINARY = hi.bin
OCTAL_CODE = hi.txt

# Default target
all: $(OCTAL_CODE)

# Assemble the bootloader
$(BINARY): hi.asm
	$(ASM) $(ASM_FLAGS) hi.asm -o $(BINARY)

# Generate the octal code
$(OCTAL_CODE): $(BINARY)
	$(OD) -A n -t o1 $(BINARY) > $(OCTAL_CODE)

# Clean up generated files
clean:
	rm -f $(BINARY) $(OCTAL_CODE)

# Phony targets (targets that don't correspond to actual files)
.PHONY: all clean
