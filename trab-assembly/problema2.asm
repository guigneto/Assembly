
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

ORG 100h

; Imprime 
PUTS msg
        
; Input do numero
CALL SCAN_NUM
MOV numero, CX ; armazena
           
; Checa se primo

    ; Calcula n/2
    MOV DX, 0      ; Reseta o registrador com resto
    MOV AX, numero ;
    DIV metade     ;

    ; Salvando n/2
    MOV metade, AX

    ; Contador ate n/2
    MOV CX, AX    

    ; Loop para descobrir se Primo
    p1: CMP CL, 1 ; Caso chegue ate 1 sem multiplos = Primo
    JE primo

    ; Divisao com contador (CL)
    MOV DX, 0      ; Reseta o resto
    MOV AX, numero ; 
    DIV CL         ;

    CMP DX, 0    ; Se encontra um múltiplo = Nao e primo
    JE not_primo ; 

    loop p1

; Primo
primo:
        BREAKLINE
        BREAKLINE
        PUTS msg_primo ; Mensagem que o numero e primo
   JMP stop

not_primo:
        BREAKLINE
        PUTS msg_not_primo

        BREAKLINE
        PUTS msg_not_primo2

        MOV AX, numero ; Insere o numero em AL
        MOV CX, metade ; Insere a metade do numero no contador
        JMP multiplos  ; Jump para encontrar e listar multiplos 

multiplos: ; Loop mas nao e um loop
        CMP CX, 0 ; Finaliza se o contador = 0
        JE stop_m ; 

        MOV DX, 0      ; Se resto 0 = Multiplo
        MOV AX, numero ; 
        DIV CX         ;

        CMP DX, 0         ; Compara o resto com 0
        JE print_multiplo ; Se multiplo, imprime o multiplo (CL) e decrementa CL
        JNE decrementa    ; So decrementa CL

print_multiplo:
        MOV AX, CX     ;
        CALL PRINT_NUM ; Imprime
        PUTC ' '   
        JMP decrementa ; Decrementa

decrementa:
     DEC CX        ; Decrementa CL
     JMP multiplos ; Volta para multiplos

stop:
   RET ; Finaliza

stop_m:
   RET        ; Finaliza

;Prints
msg db 'Insira um numero: $'
msg_primo db 'Esse numero e primo. $'        
msg_not_primo db 'Esse numero nao e primo. $'
msg_not_primo2 db 'Seus divisores sao: $'

;Variaveis
numero dw ?
contador db 0
metade dw 2


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

;quebra linha
BREAKLINE MACRO
    putc 0Dh
    putc 0Ah
ENDM

; gets the multi-digit SIGNED number from the keyboard,
; and stores the result in CX register:
SCAN_NUM        PROC    NEAR
        PUSH    DX
        PUSH    AX
        PUSH    SI
        
        MOV     CX, 0

        ; reset flag:
        MOV     CS:make_minus, 0

next_digit:

        ; get char from keyboard
        ; into AL:
        MOV     AH, 00h
        INT     16h
        ; and print it:
        MOV     AH, 0Eh
        INT     10h

        ; check for MINUS:
        CMP     AL, '-'
        JE      set_minus

        ; check for ENTER key:
        CMP     AL, 0Dh  ; carriage return?
        JNE     not_cr
        JMP     stop_input
not_cr:


        CMP     AL, 8                   ; 'BACKSPACE' pressed?
        JNE     backspace_checked
        MOV     DX, 0                   ; remove last digit by
        MOV     AX, CX                  ; division:
        DIV     CS:ten                  ; AX = DX:AX / 10 (DX-rem).
        MOV     CX, AX
        PUTC    ' '                     ; clear position.
        PUTC    8                       ; backspace again.
        JMP     next_digit
backspace_checked:


        ; allow only digits:
        CMP     AL, '0'
        JAE     ok_AE_0
        JMP     remove_not_digit
ok_AE_0:        
        CMP     AL, '9'
        JBE     ok_digit
remove_not_digit:       
        PUTC    8       ; backspace.
        PUTC    ' '     ; clear last entered not digit.
        PUTC    8       ; backspace again.        
        JMP     next_digit ; wait for next input.       
ok_digit:


        ; multiply CX by 10 (first time the result is zero)
        PUSH    AX
        MOV     AX, CX
        MUL     CS:ten                  ; DX:AX = AX*10
        MOV     CX, AX
        POP     AX

        ; check if the number is too big
        ; (result should be 16 bits)
        CMP     DX, 0
        JNE     too_big

        ; convert from ASCII code:
        SUB     AL, 30h

        ; add AL to CX:
        MOV     AH, 0
        MOV     DX, CX      ; backup, in case the result will be too big.
        ADD     CX, AX
        JC      too_big2    ; jump if the number is too big.

        JMP     next_digit

set_minus:
        MOV     CS:make_minus, 1
        JMP     next_digit

too_big2:
        MOV     CX, DX      ; restore the backuped value before add.
        MOV     DX, 0       ; DX was zero before backup!
too_big:
        MOV     AX, CX
        DIV     CS:ten  ; reverse last DX:AX = AX*10, make AX = DX:AX / 10
        MOV     CX, AX
        PUTC    8       ; backspace.
        PUTC    ' '     ; clear last entered digit.
        PUTC    8       ; backspace again.        
        JMP     next_digit ; wait for Enter/Backspace.
        
        
stop_input:
        ; check flag:
        CMP     CS:make_minus, 0
        JE      not_minus
        NEG     CX
not_minus:

        POP     SI
        POP     AX
        POP     DX
        RET
make_minus      DB      ?       ; used as a flag.
SCAN_NUM        ENDP

; this procedure prints number in AX,
; used with PRINT_NUM_UNS to print signed numbers:
PRINT_NUM       PROC    NEAR
        PUSH    DX
        PUSH    AX

        CMP     AX, 0
        JNZ     not_zero

        PUTC    '0'
        JMP     printed

not_zero:
        ; the check SIGN of AX,
        ; make absolute if it's negative:
        CMP     AX, 0
        JNS     positive
        NEG     AX

        PUTC    '-'

positive:
        CALL    PRINT_NUM_UNS
printed:
        POP     AX
        POP     DX
        RET
PRINT_NUM       ENDP

; this procedure prints out an unsigned
; number in AX (not just a single digit)
; allowed values are from 0 to 65535 (FFFF)
PRINT_NUM_UNS   PROC    NEAR
        PUSH    AX
        PUSH    BX
        PUSH    CX
        PUSH    DX

        ; flag to prevent printing zeros before number:
        MOV     CX, 1

        ; (result of "/ 10000" is always less or equal to 9).
        MOV     BX, 10000       ; 2710h - divider.

        ; AX is zero?
        CMP     AX, 0
        JZ      print_zero

begin_print:

        ; check divider (if zero go to end_print):
        CMP     BX,0
        JZ      end_print

        ; avoid printing zeros before number:
        CMP     CX, 0
        JE      calc
        ; if AX<BX then result of DIV will be zero:
        CMP     AX, BX
        JB      skip
calc:
        MOV     CX, 0   ; set flag.

        MOV     DX, 0
        DIV     BX      ; AX = DX:AX / BX   (DX=remainder).

        ; print last digit
        ; AH is always ZERO, so it's ignored
        ADD     AL, 30h    ; convert to ASCII code.
        PUTC    AL


        MOV     AX, DX  ; get remainder from last div.

skip:
        ; calculate BX=BX/10
        PUSH    AX
        MOV     DX, 0
        MOV     AX, BX
        DIV     CS:ten  ; AX = DX:AX / 10   (DX=remainder).
        MOV     BX, AX
        POP     AX

        JMP     begin_print
        
print_zero:
        PUTC    '0'
        
end_print:

        POP     DX
        POP     CX
        POP     BX
        POP     AX
        RET
PRINT_NUM_UNS   ENDP

ten             DW      10 ; used as multiplier/divider by SCAN_NUM & PRINT_NUM_UNS.