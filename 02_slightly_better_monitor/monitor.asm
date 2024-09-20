[BITS 16]
[ORG 0x7C00] ; BIOS loads the boot sector here

; Main loop
main:
    call print_prompt
    mov si, program ; Initialize pointer to the program array
input_loop:
    mov cx, 3 ; Read 3 digits
read_input:
    ; Read a character from the keyboard
    call getche

    ; Handle 'm'
    cmp al, 'm'
    jne handle_digit
    call print_program
    jmp read_input

handle_digit:
    sub al, '0' ; Convert ASCII to numerical value
    cmp al, 7
    ja execute_program ; If input is greater than '7', jump to execute the program

    ; Multiply the current byte by 8 and add the new digit
    mov bl, byte [si]
    shl bl, 3
    add bl, al
    mov byte [si], bl
    loop read_input

    ; Move to the next byte in the program array
    call print_space
    inc si
    jmp input_loop

; Execute the program stored in memory
execute_program:
    mov si, executing_msg
    call print_string
    call program

    ; Infinite loop (halt the CPU)
    jmp $

; Print program buffer to screen
print_program:
    call print_new_line
    push si
    mov si, program
.again:
    lodsb
    or al, al
    jz .done
    call print_hex_byte
    call print_space
    jmp .again
.done:
    call print_new_line
    pop si
    ret

print_new_line:
    push si
    mov si, new_line
    call print_string
    pop si
    ret

print_space:
    push ax
    mov al, ' '
    call print_char
    pop ax
    ret

print_prompt:
    push si
    mov si, prompt
    call print_string
    pop si
    ret

print_char:
    mov ah, 0x0E
    int 0x10
    ret

print_string:
    lodsb ; Loads a byte, word or dw from the source operand into the AL, AX or EAX register, respectively
    or al, al
    jz .done
    mov ah, 0x0E
    int 0x10
    jmp print_string
.done:
    ret

; Input: AL <- byte to print
print_hex_byte:
    push ax

    ; Print high nibble
    mov ah, al    ; Move AL to AH (AX = AL)
    shr al, 4     ; Shift right to get the high nibble into AL
    call print_hex_nibble

    ; Print the low nibble
    pop ax        ; Restore AX (AL contains the original byte)
    and al, 0x0F  ; Mask out the upper nibble to get the low nibble
    call print_hex_nibble
    ret

; Input: AL contains a nibble
print_hex_nibble:
    cmp al, 9          ; Check if it's a digit
    jbe .digit
    add al, 'A' - 10   ; If it's not, convert to ASCII letter A-F
    jmp .done

.digit:
    add al, '0'       ; If a digit, convert to ASCII number 0-9

.done:
    ; Print the ASCII character
    mov ah, 0x0E
    int 0x10
    ret

; Function: getche - Get a character from keyboard and display it
getche:
    mov ah, 0x00
    int 0x16
    mov ah, 0x0E
    int 0x10
    ret

program_ptr: dw program        ; Current memoty address for cursor/input
prompt: db '>', 0           ; Prompt symbol
new_line: db 0x0A, 0x0D, 0
executing_msg: db 0xA,0xD,'Executing...',0xA,0xD,0
program: times 510-($-$$) db 0
; Boot sector signature
dw 0xAA55
