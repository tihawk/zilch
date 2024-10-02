[BITS 16]
[ORG 0x7C00] ; BIOS loads the boot sector here

; Main loop
main:
    call load_program ; Load the program from disk (if it exists)
    mov si, program ; Initialize pointer to the program array
input_loop:
    call print_new_line
    call print_prompt
    mov cx, 3 ; Read 3 digits
read_input:
    ; Read a character from the keyboard
    call getche

    ; Handle 'm' (Print program)
    cmp al, 'm'
    jne handle_s
    call print_program
    call print_new_line
    call print_prompt
    jmp read_input

    ; Handle 's' (Save program)
handle_s:
    cmp al, 's'
    jne handle_backspace
    call save_program
    call print_new_line
    call print_prompt
    jmp read_input

    ; Handle backspace
handle_backspace:
    cmp al, 0x08
    jne handle_digit
    cmp cx, 3         ; Check if we are reading a brand new byte
    jb .clear_byte
    dec si
.clear_byte:
    mov byte [si], 0
    call print_delete
    jmp input_loop

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
    inc si
    jmp input_loop

; Execute the program stored in memory
execute_program:
    mov si, executing_msg
    call print_string
    call program

    ; Infinite loop (halt the CPU)
    jmp $

; Save the program to the floppy disk
save_program:
    mov ah, 0x03         ; Read disk sectors with verify
    mov al, 1            ; Number of sectors to write
    mov ch, 0            ; Cylinder 0
    mov cl, 2            ; Sector 2 (we save it on sector 2 to avoid overwriting boot sector)
    mov dh, 0            ; Head 0
    mov dl, 0            ; Drive 0 (floppy)
    mov bx, program      ; Address of the program buffer
    int 0x13             ; BIOS interrupt to write the program to the disk
    jc write_error       ; Jump to error handler if there's a failure
    call print_save_success
    ret

write_error:
    call print_save_error
    ret

; Load the program from the floppy disk (if exists)
load_program:
    mov ah, 0x02         ; BIOS function to read disk sectors
    mov al, 1            ; Number of sectors to read
    mov ch, 0            ; Cylinder 0
    mov cl, 2            ; Sector 2 (our program is stored here)
    mov dh, 0            ; Head 0
    mov dl, 0            ; Drive 0 (floppy)
    mov bx, program      ; Address to store the loaded program
    int 0x13             ; BIOS interrupt to read from the disk
    jc read_error        ; If error, skip loading
    ret

read_error:
    call print_load_error
    ret

; Print program buffer to screen with memory addresses
print_program:
    call print_new_line
    push si
    mov si, program
    mov di, [program_ptr] ; Set DI to point to the start of the program

.again:
    lodsb                 ; Load a byte from the program buffer into AL
    or al, al
    jz .done              ; If the byte is zero, we've reached the end of the program

    ; Print memory address (SI)
    push ax
    mov ax, di            ; Copy DI (memory address) into AX
    call print_hex_word   ; Print memory address in hex
    pop ax

    ; Print the byte in hex
    call print_colon      ; Print a colon after the address
    call print_hex_byte   ; Print the byte from the program buffer

    call print_space      ; Print a space after the byte

    inc di                ; Increment memory address pointer
    jmp .again

.done:
    call print_new_line
    pop si
    ret

print_colon:
    push ax
    mov al, ':'
    call print_char
    pop ax
    ret

; Input: AX contains the word (16-bit address) to print in hex
print_hex_word:
    push ax

    ; Print high byte (AH)
    mov al, ah            ; Move AH to AL (get the high byte)
    call print_hex_byte   ; Print the high byte

    ; Print low byte (AL)
    pop ax                ; Restore AX (AL contains the low byte)
    call print_hex_byte   ; Print the low byte
    ret


print_delete:
    push si
    call print_new_line
    mov si, del_cmd
    call print_string
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
    lodsb ; Load byte from memory at [si] into al
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

; Print success and error messages
print_save_success:
    mov si, save_success_msg
    call print_string
    ret

print_save_error:
    mov si, save_error_msg
    call print_string
    ret

print_load_error:
    mov si, load_error_msg
    call print_string
    ret

program_ptr: dw program        ; Current memory address for cursor/input
prompt: db '>', 0           ; Prompt symbol
new_line: db 0x0A, 0x0D, 0  ; New line
del_cmd: db 'DEL', 0
executing_msg: db 0xA, 0xD,'Executing...',0xA,0xD,0
save_success_msg: db 0xA, 0xD, 'Program saved!', 0xA, 0xD, 0
save_error_msg: db 0xA, 0xD, 'Error saving to disk!', 0xA, 0xD, 0
load_error_msg: db 0xA, 0xD, 'Error loading from disk!', 0xA, 0xD, 0

times 510-($-$$) db 0 ; Program storage buffer
; Boot sector signature
dw 0xAA55

program: times 512 db 0;
