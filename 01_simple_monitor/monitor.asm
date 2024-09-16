[BITS 16]
[ORG 0x7C00] ; BIOS loads the boot sector here

; Define variables
program: times 32 db 0

; Main loop
main:
    mov si, program ; Initialize pointer to the program array
input_loop:
    mov cx, 3 ; Read 3 digits
digit_input:
    ; Read a character from the keyboard
    call getch
    sub al, '0' ; Convert ASCII to numerical value
    cmp al, 7
    ja execute_program ; If input is greater than '7', jump to execute the program

    ; Multiply the current byte by 8 and add the new digit
    mov bl, byte [si]
    shl bl, 3
    add bl, al
    mov byte [si], bl
    loop digit_input

    ; Move to the next byte in the program array
    inc si
    jmp input_loop

; Execute the program stored in memory
execute_program:
    call program

    ; Infinite loop (halt the CPU)
    jmp $

; Function to read a character from the keyboard using BIOS interrupt 0x16
getch:
    mov ah, 0x00
    int 0x16
    ret

; Boot sector signature
times 510-($-$$) db 0
dw 0xAA55

