
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

ORG 100h

LEA SI, msg

CALL print_me


RET


msg DB 'Hello World!',0 ;string terminada com 0 (NULL) 


print_me PROC  
    
    next_char:

    CMP b.[SI], 0   ;Compara se o char eh NULL
    JE stop         ;Pula para instrucao de parada

    MOV AL, [SI]    ;Move o caractere apontado por SI para AL

    MOV AH, 0Eh     ;Interrupcao de print
    INT 10h

    ADD SI, 1       ;Incrementa SI para apontar para o proximo caractere da string
    
    JMP next_char


    stop:
    RET 
    
print_me ENDP