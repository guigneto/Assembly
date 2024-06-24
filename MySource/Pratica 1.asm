;; PRATICA 1 - DEMONSTRACAO DE ESCRITA DE STRING

; this macro prints a char in AL and advances
; the current cursor position:
PUTC    MACRO   char
        PUSH    AX
        MOV     AL, char
        MOV     AH, 0Eh
        INT     10h     
        POP     AX
ENDM

PUTS    MACRO string
        PUSH DX
        PUSH AX
        lea dx, string
        mov ah, 9
        int 21h 
        POP AX
        POP DX
ENDM

org 100h


; Imprime string
 
PUTS msg1

; Pula Linha:
putc 0Dh
putc 0Ah

; Imprime opmsg    
PUTS msg2


ret

; Prints:
msg1 db "Mensagem 1 $"
msg2 db "Mensagem 2 $"
