

;print char
PUTC    MACRO   char     
        PUSH    AX       ;PUSH e POP para preservar oque estiver no AX
        MOV     AL, char
        MOV     AH, 0Eh
        INT     10h     
        POP     AX
ENDM

;print string
PUTS    MACRO string     
        PUSH DX
        PUSH AX
        lea dx, string
        mov ah, 9       ;string has to end with $
        int 21h 
        POP AX
        POP DX
ENDM