# Variables
ASM = nasm
ASM_FLAGS = -f bin
QEMU = qemu-system-i386
OD = od
OD_FLAGS = -A n -t o1 -v

# Files
SRC = monitor.asm
BIN = monitor.bin
IMG = floppy.img
OCTAL_CODE = monitor.txt

# Default target
all: $(OCTAL_CODE)

# Assemble the assembly code into a binary
$(BIN): $(SRC)
	$(ASM) $(ASM_FLAGS) -o $(BIN) $(SRC)

# Generate the octal code
$(OCTAL_CODE): $(IMG)
	$(OD) $(OD_FLAGS) $(BIN) > $(OCTAL_CODE)

# Create a bootable floppy image
$(IMG): $(BIN)
	dd if=/dev/zero of=$(IMG) bs=512 count=2880
	dd if=$(BIN) of=$(IMG) conv=notrunc

# Run the floppy image in QEMU
run: $(IMG)
	$(QEMU) -fda $(IMG)

# Clean up generated files
clean:
	rm -f $(BIN) $(IMG) $(OCTAL_CODE)

# Phony targets
.PHONY: all run clean
