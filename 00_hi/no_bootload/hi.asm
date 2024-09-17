[BITS 16]
mov ah, 0x0E       ; BIOS teletype output
mov al, 'H'        ; Character 'H'
int 0x10           ; Call BIOS interrupt to display character

mov ah, 0x0E       ; BIOS teletype output
mov al, 'i'        ; Character 'i'
int 0x10           ; Call BIOS interrupt to display character

hlt                ; Halt the CPU

