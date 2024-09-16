# Variables
ASM = nasm
ASM_FLAGS = -f bin
QEMU = qemu-system-i386
BOOTLOADER = hi.bin
FLOPPY_IMG = floppy.img

# Default target
all: $(FLOPPY_IMG)

# Assemble the bootloader
$(BOOTLOADER): hi.asm
	$(ASM) $(ASM_FLAGS) hi.asm -o $(BOOTLOADER)

# Create the floppy image and write the bootloader to it
$(FLOPPY_IMG): $(BOOTLOADER)
	dd if=/dev/zero of=$(FLOPPY_IMG) bs=512 count=2880
	dd if=$(BOOTLOADER) of=$(FLOPPY_IMG) conv=notrunc

# Run the floppy image in QEMU
run: $(FLOPPY_IMG)
	$(QEMU) -fda $(FLOPPY_IMG)

# Clean up generated files
clean:
	rm -f $(BOOTLOADER) $(FLOPPY_IMG)

# Phony targets (targets that don't correspond to actual files)
.PHONY: all run clean
