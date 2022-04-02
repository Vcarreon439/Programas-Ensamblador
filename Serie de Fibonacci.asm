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

Macro ImprimirComa
    
    ;Imprimimos una coma
    MOV DX, offset espa
    MOV AH, 09h
    INT 21H
    
ENDM

Macro Solicitar_Num mensaje, num
    
    ;Imprimirmos el mensaje de bienvenida
    MOV DX, offset msm
    MOV AH, 09H
    INT 21H
    
    ;Solicitamos el primer digito
    MOV AH,01H
    INT 21H
    SUB AL,30H
    
    MOV BX,AX
    MOV BH,00
    MOV AX,10
    MUL BX
    MOV BX,AX
    
    ;Solicitamos el segundo digito
    MOV AH,01H
    INT 21H
    
    ;Combinamos ambos numeros
    MOV AH,00
    SUB AL,30H
    ADD BX,AX
             
    ;Comparacion en caso de exceder 24 iteraciones
    CMP BX,24
    JA  Excepcion
    
    ;Comparacion en caso de ingresar 0
    CMP BX,00
    JE  Finalizar

    ;Decrementamos en uno, por contar de manera binaria
    ;0,1,2,3,4,...    
    SUB BX,1
                  
    ;Almacenamos el contador                 
    MOV contador, BX
    
ENDM

.model small
.stack 32
.data

    msm db "Ingrese a cantidad de iteraciones: $"
    ms2 db 10,13, "El resultado es: $"
    error db 10,13, "El programa solo soporta 24 iteraciones!!$"
    espa db ",$"
    
    origen dw 0
    resultado dw 1
    contador dw ?
    
    str db 6 dup('$')
    
.code
   
mov ax,@data    ;Segmento de datos
mov ds,ax

XOR AX, 00
MOV BX, 01      ;Guardamos en BX la base

Iniciar:

    Configurar

    Solicitar_Num msm, contador

    ;Mensaje y salto de linea para mejor escritura
    mov  dx, offset ms2
    mov  ah, 09h
    int  21h
    
    ;Numero y coma para mejor escritura
    mov  dx, 30h
    mov  ah, 02h
    int  21h
    
    ImprimirComa
    
    ;;Numero y coma para mejor escritura
    mov  dx, 31h
    mov  ah, 02h
    int  21h
    
    ImprimirComa
    
Factorial:

    ;Cargamos los valores a BX y AX respectivamente,
    ;para iniciar la serie de Fibonacci
    MOV AX,origen
    MOV BX,resultado
    ;Cargamos los valores a CX para el contador
    MOV CX,contador
    
    ;Realizamos una comparacion para saber si finalizar el ciclo
    CMP CX,00
    JE Finalizar
    
    ;Decrementamos el contador
    DEC CX
    MOV contador, CX

    ;Realizamos la operacion    
    ADD AX,BX
    
    ;Reasignamos los valores a las variables
    MOV resultado, AX
    MOV origen,BX
    
    ;Imprimimos el numero
    call numeroAcadena
    MOV DX, offset str
    mov  ah, 09h
    int  21h
    
    ;Coma para el formato
    ImprimirComa
    
    ;Reiniciamos el ciclo
    jmp Factorial

Finalizar:

    ;Esperamos entrada del usuario
    mov  ah,7
    int  21h
    
    ;Finalizamos el programa.
    mov  ax, 4c00h
    int  21h
  
Excepcion:

    ;Mostramos el mensaje de error
    MOV DX, offset error
    MOV AH, 09H
    INT 21H
    
    ;Esperamos entrada del usuario
    mov  ah,7
    int  21h
     
    ;Reiniciamos el programa 
    JMP Iniciar
               
;------------------------------------------
;El valor de la cadena debe estar en AX
;Resta los digitos del numero, uno por uno
;Elimina los numeros de la pila y los inserta en la matriz

proc numeroAcadena
                        
  mov  bx, 10   ;Los numeros se restan dividiendo por 10, el 10 asignado a BX
  mov  cx, 0    ;El contrador esta configurado para los numeros restados
  
ciclo1:       
  mov  dx, 0    ;El valor en DX se reestablece, y DX se usa como apuntador
                ;El valor restante de esta seccion contendra el digito extraido
  div  bx       ;El valor en AX se divide por BX (10)
  push dx       ;DX se agrega a la pila de digitos
  inc  cx       ;El contador 'CX' se incrementa en 1
  cmp  ax, 0    ;El proceso continua hasta que AX = 0
  jne  ciclo1

  mov  si, offset str   ;Se asigna el valor a la cadena
  
ciclo2:  
  pop  dx        
  add  dl, 48   ;Los valores de la pila se eliminan uno por uno y se asignan a str
  mov  [ si ], dl
  inc  si
  loop ciclo2

  ret
endp
 
end