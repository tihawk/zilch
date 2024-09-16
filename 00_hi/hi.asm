[BITS 16]        ; Use 16-bit mode (x86 real mode)
[ORG 0x7C00]     ; Origin - BIOS loads boot sector at memory address 0x7C00

start:
    ; Print 'H'
    mov ah, 0x0E   ; BIOS teletype output function (INT 10h, AH=0Eh)
    mov al, 'H'    ; Character to print
    int 0x10       ; Call BIOS interrupt to display the character

    ; Print 'i'
    mov ah, 0x0E   ; BIOS teletype output function
    mov al, 'i'    ; Character to print
    int 0x10       ; Call BIOS interrupt to display the character

    ; Infinite loop to prevent the bootloader from proceeding
hang:
    jmp hang

; Boot sector signature (must be 0xAA55 for BIOS to recognize it as bootable)
times 510-($-$$) db 0   ; Fill the rest of the boot sector with zeros
dw 0xAA55               ; Boot sector magic number

