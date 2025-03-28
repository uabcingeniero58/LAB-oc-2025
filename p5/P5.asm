%include "pc_iox.inc"

section. data
 N dw 0       
 cociente db 0
 residuo db 0
 flag_str db "EFLAGS: ", 0
 newline db 10, 0

section. bss

section .text
  global _start       ;must be declared for using gcc

  _start:

;a.- Coloque en EBX el valor 0x5C4B2A60. Sume	su matrícula como valor hexadecimal
 mov ebx, 0x5C4B2A60
 add ebx, 0x2203421
 call pHex_dw

;b.- Coloque los 16 bits menos	significativos de EBX en la	pila.

 push bx
 call puts

;c.-Defina	una	variable	N	de	2	bytes	de	longitud.	En	ella,	guarde	el	resultado	de	la	
multiplicación	de	BL	por	8,	sin	considerar	los	signos

 mov al, bl
 mov cl, 8
 mul cl               ; Resultado en AX
 mov [N], ax
 call puts

;d.- incrementar el valor 1 en N
 inc word [N]
 call puts

;e.- Divida	el	valor	almacenado	en	BX	entre	0xFF.	Imprima	tanto	el	cociente	como	el	residuo	
de	la	operación.
 mov ax, bx           ; Mover BX a AX ´para division
 mov cl, 0xFF
 div cl 
 call puts   

;f.- Realice	la	suma	entre	el	valor	almacenado	en	N	y	el	residuo	de	la	división	anterior.	
Guarde	el	valor	en	N	y	decremente	N.	Realice	las	operaciones	necesarias	para	imprimir	
el	registro	de	banderas	y	explique	qué	banderas	están	activas	y	la	razón	del	porqué	
están	activas.

 movzx ax, byte [residuo]
 add [N], ax
 dec word [N]
 call puts
    
; obtener las EFLAGS y imprimirlas
 pushf                ; enpuja las banderas al stack
 pop eax              ; Pop las banderas en EAX
 call puts

;g.- Saque undato de 16 bits de la pila.	
 pop bx
 call puts
    
;salir
    mov eax, 1
    mov ebx, 0
    int 0x80
