org 0x7C00 ; Base offset for all code
bits 16 ; Omits 16 bit code

%define ENDL 0x0D, 0x0A

start:
    jmp main
;
; Prints a string to the screen.
; Params:
;   - ds:si points to String
;
puts:
    ; save registers we will modify
    push si
    push ax

.loop:
    lodsb
    or al, al           ; loads next character in al
    jz .done            ; verify if next character is null

    mov ah, 0x0E        ; call bios interupt
    mov bh, 0
    int 0x10

    jmp .loop

.done:
    pop ax
    pop si
    ret



main:

    ; setup data segment
    mov ax, 0           ; can't write to ds/es directly
    mov ds, ax
    mov es, ax

    ; setup stack
    mov ss, ax          
    mov sp, 0x7C00      ; stack grows downwards from wherever we are loaded in memory

    ; print message
    mov si, msg_hello
    call puts

    hlt

.halt:
    jmp .halt

msg_hello: db 'Hello world!', ENDL, 0
times 510-($-$$) db 0 ; Padding 0s until final two bytes
dw 0AA55h