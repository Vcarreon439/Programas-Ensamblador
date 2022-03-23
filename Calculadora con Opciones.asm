MACRO IMPRIMIR F,C,texto
    ;FUNCION PARA IMPRIMIR UN TEXTO, DADAS UNAS COORDENADAS EN PANTALLA
    MOV AH,02H
    ;Posicion en X del cursor
    MOV DH,F
    ;Posicion en Y del cursor
    MOV DL,C
    INT 10H 
    ;El texto a imprimir en las coordenadas X,Y
    MOV dx,offset texto
    MOV ah,09h
    INT 21h
    
ENDM

MACRO FLUSH
    ;Limpia los espacio de BX, esto para evitar conflictos con la pantalla
    MOV BX,00H
ENDM

MACRO CONFIGURAR 
               
      MOV AX,0600H;Limpiar pantalla... AL = 00H limpia todos los renglones
      
      MOV BH,5BH  ;color de fondo yletra
      MOV CX,0000H ;esquina sup.izquierda de la pantalla(0,0)
      MOV DX,184FH ;esquina inf. derecha de la pantalla(24,79)
      INT 10H
      
      MOV AH,02H 
      MOV DX,00H ;posiscion del cursor(0,0) despues de limpiar pantalla
      MOV BH,00H ;Pagina 0
      INT 10H
    
ENDM

MACRO SOLICITAR_NUM
    
    ;Solicita los numeros
    MOV AH,01H
    INT 21h
    
ENDM


MACRO AJUSTAR
    ;Reducir en 30 los valores de AL y BL    
    SUB AL, 30H
    SUB BL, 30H
    
ENDM

MACRO IMPRESULTADO
    
    ;Imprime resultados de 2 digitos
    
    ;Imprimimos el primer digito  
    ADD bh, 30h
    MOV dl, bh
    MOV ah, 02
    INT 21h
    
    ;Imprimimos el segundo digito
    ADD bl, 30h
    MOV dl, bl
    MOV ah, 02
    INT 21h
    
ENDM

DATOS SEGMENT
    
    VAL1 DB ?
    VAL2 DB ? 
    VAL3 DB ?
    
    TXT1 DB "INSTITUTO TECNOLOGICO SUPERIOR DE LERDO$"
    
    LN1 DB "*******************************************************$"
    
    TXT2 DB "LENGUAJES DE INTERFAZ$"
    TXT3 DB "DOCENTE: CHRISTIAN ALVAREZ MUNOZ$"
    TXT4 DB "ALUMNO: VICTOR HUGO CARREON PULIDO$"
    TXT5 DB "# DE CONTROL 192310436$"
    FECHA DB "MARZO - 2022$"
    CONT DB "DESEA CONTINUAR? (SI/NO) $"
    CONTB DB "PRESIONE CUALQUIER TECLA PARA CONTINUAR $"
    NOTIMP DB "FUNCION AUN NO IMPLEMENTADA$"
    TXTFIN DB "FIN DEL PROGRAMA$"
    
    OPCA DB "OPCIONES$"
    OPCB DB "PORFAVOR ELIGA UNA OPCION: $"
    OPC1 DB "1. SUMAR $"
    OPC2 DB "2. RESTAR $"
    OPC3 DB "3. MULTIPLICAR $"
    OPC4 DB "4. DIVIDIR $"
    OPC5 DB "5. COMPARAR $"
    OPC6 DB "6. INFORMACION DEL PROGRAMA$"
    OPC7 DB "7. SALIR DEL PROGRAMA$"
    
    DOC1 DB "Este programa permite realizar algunas operaciones$"
    DOC2 DB "como suma, resta, multiplicacion, division y comparacion.$"
    DOC3 DB "Solo soporta operaciones con un digito y tiene un limite$"
    DOC4 DB "de longitud decimal (99), y no proporciona resultados fraccionarios$"
    DOC5 DB "Habiendo mencionado esto, entre las caracteristicas principales$"
    DOC6 DB "esta la resta que no se desborda con negativos y multiplicacion que$"
    DOC7 DB "no se desborda (sin llegar al limite de 99 decimal)$"
    
    SOL1 DB "Ingrese el primer numero: $"
    SOL2 DB "Ingrese el segundo numero: $"
    
    RESUL DB "RESULTADO = $"
    RESI DB "RESIDUO = $"
    
    COMP1 db ' > $'
    COMP2 db ' < $'
    COMP3 db ' = $'
    
    
   
    
ENDS

             
PROGRAMA SEGMENT
     ASSUME CS:CODIGO, DS:DATOS

INICIO:

    MOV AX, DATOS
    MOV DS, AX
     
    ;Se configura la pantalla
    CONFIGURAR
    JE PRESENTACION
   
    
PRESENTACION:   
    ;Muestra la informacion inicial del programa
    ;Es decir datos del autor y de la institucion
    MOV BX,00H
    IMPRIMIR 1,20,TXT1 
    IMPRIMIR 3,29,TXT2
    IMPRIMIR 5,24,TXT3
    IMPRIMIR 7,23,TXT4
    IMPRIMIR 9,29,TXT5
    IMPRIMIR 21,50,FECHA
    IMPRIMIR 23,10,CONT
    
    JE ANSW1

ANSW1:

    ;Evalua la entrada del teclado y nos redirije
    ;al menu principal o sale del programa segun
    ;se desee
         
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
    JE IMPRIMIR_MENU
    
IMPRIMIR_MENU:

    FLUSH  
    
    ;Imprimimos el menu principal
    CONFIGURAR
    IMPRIMIR 1,3,LN1
    IMPRIMIR 3,5,OPCA
    IMPRIMIR 6,5,OPC1
    IMPRIMIR 7,5,OPC2
    IMPRIMIR 8,5,OPC3
    IMPRIMIR 9,5,OPC4
    IMPRIMIR 10,5,OPC5
    IMPRIMIR 11,5,OPC6
    IMPRIMIR 15,3,LN1
    IMPRIMIR 13,5,OPCB
    
    MOV AH,01H
    INT 21H
    
    FLUSH
    
    ;Se evalua segun el digito introducido
    
    CMP AL,31H
    JE SUMA
    CMP AL,32H
    JE RESTA
    CMP AL,33H
    JE MULTIPLICACION
    CMP AL,34H
    JE DIVISION
    CMP AL,35H
    JE COMPARAR
    CMP AL,36H
    JE INFO
    CMP AL,37H
    JE FIN
    
    
SUMA:
    CONFIGURAR          
    IMPRIMIR 4,2,SOL1
    SOLICITAR_NUM
    MOV VAL1, AL
    IMPRIMIR 6,2,SOL2
    SOLICITAR_NUM
    MOV VAL2, AL
    IMPRIMIR 9,2,RESUL
    
    MOV AL, VAL1
    MOV BL, VAL2
    
    AJUSTAR
    
    ADD AL, BL
    MOV VAL3, AL
    MOV AL, VAL3
    AAM
    MOV BX,AX
    
    IMPRESULTADO
    
    MOV BX,00H
    IMPRIMIR 15,2,CONTB
    MOV AH,01H
    INT 21H
    JMP IMPRIMIR_MENU 
    
        
RESTA:
    CONFIGURAR
    IMPRIMIR 4,2,SOL1
    SOLICITAR_NUM
    MOV VAL1, AL
    IMPRIMIR 6,2,SOL2
    SOLICITAR_NUM
    MOV VAL2, AL
    IMPRIMIR 9,2,RESUL
             
    
    MOV AL, VAL1
    MOV BL, VAL2
    
    AJUSTAR
    
    CMP AL, BL
    
    JA mayor
    JB menor
    JE mayor
   
mayor:

    ;En caso de ser mayor, el flujo de la resta es el esperado
    MOV AL,VAL1
    MOV BL,VAL2
    SUB AL,BL
    MOV VAL3,AL
        
    ;Imprimimos el resultado de la resta    
    MOV DL,VAL3
    ADD DL,30h
    MOV AH,02
    INT 21h
    
    FLUSH
    IMPRIMIR 15,2,CONTB
    MOV AH,01H
    INT 21H
    
    JMP IMPRIMIR_MENU


menor:

    ;En caso de ser menor, imprimimos primero el signo negativo
    MOV AH,02
    MOV DL,45
    INT 21h
    
    ;Realizamos la resta de manera inversa siendo esta
    ;(NumMayor) - (NumMenor)
    MOV al,VAL2
    MOV bl,VAL1
    SUB al,bl
    MOV VAL3,al
    
    ;Imprimirmos el digito resultante de la resta inversa        
    MOV dl,VAL3
    ADD dl,30h
    MOV ah,02
    INT 21h
    
    
    FLUSH
    IMPRIMIR 15,2,CONTB
    MOV AH,01H
    INT 21H
    
    JMP IMPRIMIR_MENU

    
MULTIPLICACION:

    CONFIGURAR
    IMPRIMIR 4,2,SOL1
    SOLICITAR_NUM
    MOV VAL1, AL
    IMPRIMIR 6,2,SOL2
    SOLICITAR_NUM
    MOV VAL2, AL
    IMPRIMIR 9,2,RESUL
    
    MOV AL, VAL1
    MOV BL, VAL2
    AJUSTAR 
    
    ;Utilizamos este procedimiento para hacer un split y poder
    ;tener resultados mayores a 1 digito.
    MUL BL
    AAM
    MOV BX, AX
    
    ;Muestra el primer digito
    ADD BH, 30h
    MOV DL, BH
    MOV AH, 02
    INT 21h
    
    ;Muestra el segundo digito
    ADD bl, 30h
    MOV dl, bl
    MOV ah, 02
    INT 21h
    
    FLUSH
    IMPRIMIR 15,2,CONTB
    MOV AH,01H
    INT 21H
    
    ;Regresamos al menu principal
    JMP IMPRIMIR_MENU

DIVISION:

    CONFIGURAR
    IMPRIMIR 4,2,SOL1
    SOLICITAR_NUM
    MOV VAL1, AL
    IMPRIMIR 6,2,SOL2
    SOLICITAR_NUM
    MOV VAL2, AL
    IMPRIMIR 9,2,RESUL
    
    ;Vaciamos la memoria AX
    XOR AX,AX
    
    ;CARGAMOS LOS VALORES
    MOV AL, VAL1
    MOV BL, VAL2
    
    ;Los ajustamos
    AJUSTAR
    
    ;Y evaluamos
    DIV BL
    MOV VAL3, AL
    ;Guardamos el resultado en una "variable"
    MOV BL, VAL3
    
    
    ;Muestra el coeficiente de la division
    ADD bl, 30h
    MOV dl, bl
    MOV ah, 02
    INT 21h

    ;Imprime "Residuo = "    
    IMPRIMIR 10,2,RESI
    
    ;Muestra el residuo de la division
    ADD dl, bh
    MOV dl, 30h
    MOV ah, 02
    INT 21h
    
    FLUSH
    IMPRIMIR 15,2,CONTB
    MOV AH,01H
    INT 21H
              
    ;Carga el menu principal
    JMP IMPRIMIR_MENU
    
COMPARAR:
    
    CONFIGURAR
    IMPRIMIR 4,2,SOL1
    SOLICITAR_NUM
    MOV VAL1, AL
    IMPRIMIR 6,2,SOL2
    SOLICITAR_NUM
    MOV VAL2, AL
    IMPRIMIR 9,2,RESUL
    
    ;Cargamos los valores
    MOV AL,VAL1
    MOV BL,VAL2
    
    ;Los ajustamos (-30h)
    AJUSTAR
    
    ;Evaluamos
    CMP AL,BL

    ;Casos    
    JA MAYORC
    JB MENORC
    JE IGUALC
    
    
MAYORC:

    ;En caso de ser mayor

    ;Mostrar numero 1
    mov AL,VAL1
    mov AH,02H
    mov DL,AL
    int 21h 

    ;Mostrar simbolo
    mov ah,09h
    lea dx,COMP1
    int 21h
    
    ;Mostrar numero 2
    mov AL,VAL2
    mov AH,02H
    mov DL,AL
    int 21h
    
    FLUSH
    IMPRIMIR 15,2,CONTB
    MOV AH,01H
    INT 21H
    
    jmp IMPRIMIR_MENU 
    

MENORC:

    ;En caso de ser menor

    ;Mostrar numero 1
    mov AL,VAL1
    mov AH,02h
    mov DL,AL
    int 21h 

    ;Mostrar simbolo
    mov AH,09h
    lea DX,COMP2
    int 21h
    
    ;Mostrar numero 2
    mov AL,VAL2
    mov AH,02h
    mov DL,AL
    int 21h 
    
    FLUSH
    IMPRIMIR 15,2,CONTB
    MOV AH,01H
    INT 21H
    
    jmp IMPRIMIR_MENU    

IGUALC:
    
    ;En caso de ser igual

    ;Mostrar numero 1
    mov AL,VAL1
    mov AH,02h
    mov DL,AL
    int 21h 

    ;Mostrar simbolo
    mov AH,09h
    lea DX,COMP3
    int 21h
    
    ;Mostrar numero 2
    mov AL,VAL2
    mov AH,02h
    mov DL,AL
    int 21h
    
    FLUSH
    IMPRIMIR 15,2,CONTB
    MOV AH,01H
    INT 21H
    
    jmp IMPRIMIR_MENU
    
INFO: 

    CONFIGURAR
    
    ;Carga el manual de uso del programa
    IMPRIMIR 2,5,DOC1
    IMPRIMIR 3,5,DOC2
    IMPRIMIR 5,5,DOC3
    IMPRIMIR 6,5,DOC4
    IMPRIMIR 7,5,DOC5
    IMPRIMIR 8,5,DOC6
    IMPRIMIR 9,5,DOC7
    
    IMPRIMIR 11,5,CONTB
    MOV AH,01H
    INT 21H
    
    ;Regresamos al menu principal
    JE IMPRIMIR_MENU
    
FIN: 
    ;Finaliza el programa
    CONFIGURAR
    
    IMPRIMIR 12,29,TXTFIN
    MOV AH,07H 
    INT 21H    
    MOV AH,4CH
    INT 21H
    
END INICIO