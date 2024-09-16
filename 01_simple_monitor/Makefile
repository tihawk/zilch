# Variables
ASM = nasm
QEMU = qemu-system-i386

# Files
SRC = monitor.asm
BIN = monitor.bin
IMG = floppy.img

# Default target
all: $(IMG)

# Assemble the assembly code into a binary
$(BIN): $(SRC)
	$(ASM) -f bin -o $(BIN) $(SRC)

# Create a bootable floppy image
$(IMG): $(BIN)
	dd if=/dev/zero of=$(IMG) bs=512 count=2880
	dd if=$(BIN) of=$(IMG) conv=notrunc

# Run the floppy image in QEMU
run: $(IMG)
	$(QEMU) -fda $(IMG)

# Clean up generated files
clean:
	rm -f $(BIN) $(IMG)

# Phony targets
.PHONY: all run clean

