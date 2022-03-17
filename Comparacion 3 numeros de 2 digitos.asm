
MACRO IMPRIMIR F,C,texto
    ;FUNCION PARA IMPRIMIR UN TEXTO, DADAS UNAS COORDENADAS EN PANTALLA
    ;F es para la posicion en X
    ;C es para la posicion en Y
    MOV AH,02H
    MOV DH,F
    MOV DL,C
    INT 10H 
    MOV dx,offset texto
    MOV ah,09h
    INT 21h
    
ENDM

MACRO CONFIGURAR
    
      MOV AX,0600H;Limpiar pantalla... AL = 00H limpia todos los renglones
      MOV BH,5BH  ;color de fondo yletra
      MOV CX,0000H ;esquina sup.izquierda de la pantalla(0,0)
      MOV DX,184FH ;esquina inf. derecha de la pantalla(24,79)
      INT 10H
      
      MOV AH,02H 
      MOV DX,00H ;posiscion del cursor(0,0) despues de limpiar pantalla
      MOV BH,00H  ;Pagina 0
      INT 10H
    
ENDM


MACRO EscribirNum Numero
    
    ;Macro para escribir un numero de 2 digitos, desde una variable de 8bits
    mov al,Numero
    mov ah,00
    aam
    
    mov bx, ax  

    mov dl,bh
    add dl,48
    mov ah,02h
    int 21h
    
    mov dl, bl
    add dl,48
    mov ah,02h
    int 21h
      
    FLUSH
       
ENDM

MACRO LeerNum Store    
    
    ;Macro para leer un valor y guardarlo en una variable (Store)
    mov ah,01h
    int 21h
    sub al,48
    mov bh,al
    
    mov ah,01h
    int 21h
    sub al,48
    mov bl,al     
    
    mov al,bh
    mul ten
    add al,bl
    
    mov Store,al
    
    mov dx,offset espa
    mov ah,09h
    int 21h
    
    FLUSH
    
ENDM

MACRO FLUSH
    
    mov ax, 0000h
    mov bx, 0000h
    mov cx, 0000h
    mov DX, 0000h
    
ENDM

MACRO COMPARAR N1, N2, N3
    
    ;COMPARACIONES
    FLUSH
    
    ;CMP{N1,N2}
    MOV AH, N1
    MOV AL, N2
    CMP AH, AL
    ;N1 > N2
    ja comparar1-3
    ;N1 < N2
    jc comparar2-3
    ;N1 = N2
    jz iguales1-2
    
    ;N1=N2 -> Comprobar que N1 es mayor o menor que N3    
    iguales1-2:
    mov ah, N1
    mov al, N3
    cmp ah, al
    ja mayor1
    jc mayor3
    jz IGUALES
    
    ;N1=N2=N3
    IGUALES:
    mov bh, N1
    mov bl, N2
    mov cl, N3
    
    ;CMP {N1,N2}
    comparar1-3: 
    MOV AH, N1
    MOV AL, N3
    cmp AH, AL
    ja mayor1
    jc mayor3
    
    ;Mayor entre N2 y N3    
    mayor1:
    mov BH, N1
    mov BL, N2
    mov CL, N3
    cmp BL, CL
    ja RESULTADOS
    jc AJUSTE23 
    
    ;CMP {N2,N3}        
    comparar2-3:
    mov ah, N2
    mov al, N3
    cmp ah, al
    ja mayor2
    jc mayor3
    
    ;Mayor entre N1 y N3    
    mayor2:
    mov bh,N2
    mov bl,N1
    mov cl,N3
    cmp bl,cl
    ja RESULTADOS
    jc AJUSTE13
    
    ;Mayor entre N1 y N2
    mayor3:
    mov bh, N3
    mov bl, N1
    mov cl, N2
    cmp bl, cl
    ja RESULTADOS
    jc AJUSTE12
        
    AJUSTE23:
    mov bl, N3
    mov cl, N2
    jmp RESULTADOS
    
    AJUSTE13:
    mov bl, N3
    mov cl, N1
    jmp RESULTADOS
    
    AJUSTE12:
    mov bl, N2
    mov cl, N1
    jmp RESULTADOS
    
    ;Guardamos los resultados en las variables
    RESULTADOS:
    xor ax, ax
    mov N1, bh
    mov N2, bl
    mov N3, cl
    
ENDM

MACRO IMPRIMIRDSC
    
    ;Descendente
    
    EscribirNum num3
    
    ESPACIO
    
    EscribirNum num2
    
    ESPACIO
    
    EscribirNum num1
    
ENDM

MACRO ESPACIO
    
    mov ah, 02h; Espacio
    mov dl, 44
    int 21h
    mov ah, 02h; Coma
    mov dl, 32
    int 21h
    
ENDM

MACRO IMPRIMIRASC
    
    ;Ascendente
    
    EscribirNum num1
    
    ESPACIO
    
    EscribirNum num2

    ESPACIO
    
    EscribirNum num3
    
ENDM

MACRO INTERFAZ
    
    IMPRIMIR 1,20,LN
    IMPRIMIR 2,20,LN2
    IMPRIMIR 3,20,LN2
    IMPRIMIR 4,20,LN2
    IMPRIMIR 5,20,LN2
    IMPRIMIR 6,20,LN2
    IMPRIMIR 7,20,LN2
    IMPRIMIR 8,20,LN2
    IMPRIMIR 9,20,LN2
    IMPRIMIR 10,20,LN
    
    IMPRIMIR 3,28,msg
    LeerNum num1
    
    IMPRIMIR 5,28,msg
    LeerNum num2
    
    IMPRIMIR 7,28,msg
    LeerNum num3
    
    IMPRIMIR 10,20,LN3
    
    IMPRIMIR 11,20,LN2
    IMPRIMIR 12,20,LN2
    IMPRIMIR 13,20,LN2
    IMPRIMIR 14,20,LN2
    IMPRIMIR 15,20,LN2
        
    FLUSH
    
    IMPRIMIR 12,28,ASC
    IMPRIMIRASC
    
    FLUSH
    
    IMPRIMIR 14,28,DSC
    IMPRIMIRDSC
    
    IMPRIMIR 16,20,LN
    
    IMPRIMIR 18,20,CONT
    
ENDM


DATOS SEGMENT

    num1 db 0
    num2 db 0
    num3 db 0
    
    TXT1 DB "INSTITUTO TECNOLOGICO SUPERIOR DE LERDO$"
    TXT2 DB "LENGUAJES DE INTERFAZ$"
    TXT3 DB "DOCENTE: CHRISTIAN ALVAREZ MUNOZ$"
    TXT4 DB "ALUMNO: VICTOR HUGO CARREON PULIDO$"
    TXT5 DB "# DE CONTROL 192310436$"
    TXTFIN DB "FIN DEL PROGRAMA$"
    
    LN DB  "****************************************$"
    LN2 DB "*                                      *$"
    LN3 DB "*--------------RESULTADOS--------------*$"
    
        
    FECHA DB "MARZO - 2022$"
    CONT DB "DESEA CONTINUAR? (SI/NO) $"
                      
    msg db "Ingrese un numero: $" 
    espa db 10,13, "$"
    msg2 db 10,13,"Usted ingreso: $" 
    
    asc db "Ascendente: $"
    dsc db "Descendente: $"
    
    ten db 10
    
ENDS

PROGRAMA SEGMENT
    ASSUME CS:CODIGO, DS:DATOS

INICIO:

    MOV AX, DATOS
    MOV DS, AX
    
    CONFIGURAR
        
        IMPRIMIR 1,20,TXT1 
        IMPRIMIR 3,29,TXT2
        IMPRIMIR 5,24,TXT3
        IMPRIMIR 7,23,TXT4
        IMPRIMIR 9,29,TXT5
        IMPRIMIR 21,50,FECHA
        IMPRIMIR 23,10,CONT
        
        JE ANSW1
    
ANSW1:

    MOV AH,01H
    INT 21H
    MOV BH,AL
    MOV AH,01H
    INT 21H 
    MOV BL,AL
    
    ;Comparaciones con los caracteres "S,s,I,i,N,n,O,o"
    CMP BX,5349H
    JE INGRESO
    CMP BX,4E4Fh
    JE FIN
    
    CMP BX,7369H
    JE  INGRESO 
    CMP BX,6E6FH
    JE FIN

INGRESO:
    
    CONFIGURAR
    INTERFAZ
    JMP ANSW1
        
FIN:
    CONFIGURAR
    IMPRIMIR 12,20,TXTFIN
    MOV AH, 07H
    INT 21H
    MOV AH, 4CH
    INT 21H    

END INICIO 