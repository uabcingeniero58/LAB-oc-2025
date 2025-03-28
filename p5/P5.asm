%include "../LIB/pc_iox.inc"

section .data
    N dw 0            ; Variable de 2 bytes
    cociente db 0      ; Variable para almacenar el cociente
    residuo db 0       ; Variable para almacenar el residuo
    flag_str db "EFLAGS: ", 0 ; Cadena para imprimir EFLAGS
    newline db 10, 0   ; Cambio de línea

section .text
    global _start      ; Declarar punto de entrada para el linker

_start:
    ; a. Sumar matrícula hexadecimal al valor en EBX
    mov ebx, 0x5C4B2A60
    add ebx, 0x2203421
    call pHex_dw       ; Imprimir resultado en hexadecimal

    ; b. Colocar los 16 bits menos significativos de EBX en la pila
    push bx
    call puts          ; Imprimir valor de la pila

    ; c. Multiplicar BL por 8 y guardar resultado en N (sin signo)
    mov al, bl
    mov cl, 8
    mul cl             ; Multiplicación (resultado en AX)
    mov [N], ax        ; Guardar resultado en N
    call puts          ; Imprimir N

    ; d. Incrementar el valor de N
    inc word [N]
    call puts          ; Imprimir N incrementado

    ; e. Dividir BX entre 0xFF e imprimir cociente y residuo
    mov ax, bx         ; Mover BX a AX para división
    mov cl, 0xFF
    div cl             ; División (cociente en AL, residuo en AH)
    mov [cociente], al ; Guardar cociente
    mov [residuo], ah  ; Guardar residuo
    call puts          ; Imprimir cociente y residuo

    ; f. Sumar N y residuo, guardar en N, decrementar N
    movzx ax, byte [residuo]
    add [N], ax        ; Sumar residuo a N
    dec word [N]       ; Decrementar N
    call puts          ; Imprimir nuevo valor de N

    ; Obtener las EFLAGS y mostrar
    pushf              ; Colocar las banderas en la pila
    pop eax            ; Extraer las banderas en EAX
    call puts          ; Imprimir EFLAGS

    ; g. Sacar un dato de 16 bits de la pila
    pop bx             ; Extraer valor de la pila
    call puts          ; Imprimir valor

    ; Salir del programa
    mov eax, 1         ; Número de llamada al sistema (sys_exit)
    mov ebx, 0         ; Código de salida
    int 0x80           ; Llamar al kernel
