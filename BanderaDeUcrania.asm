MACRO COLOREAR esqsup,esqinf, col
    ;Configuramos el modo de pantalla y "limpiamos"
    MOV AX, 0600H
    ;Configuramos la esquina superior
    MOV CX, esqsup
    ;Configuramos la esquina inferior
    MOV DX, esqinf
    ;Configuramos el color de fondo y de letra
    MOV BH, col
    ;
    INT 10H
ENDM

org 100h
.data
    msg db ' Carreon Pulido Victor Hugo - 192310436',13,10,' Bandera de Ucrania',"$"
    
.code
    .startup
     
    ;Coloreamos el color amarillo
    COLOREAR 00H, 184FH, 0E0H
    ;Coloreamos el color azul y configuramos el texto en gris
    COLOREAR 0000H, 094FH, 97H
    
    ;Imprimimos el mensaje
    MOV DX, offset msg    
    MOV AH,09H
    INT 21H
          
    ;Esperamos entrada del usuario para finalizar
    MOV AX,0C07H
    INT 21H
    
end