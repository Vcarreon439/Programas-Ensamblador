Macro Solicitar_Num
    
    MOV DX, offset msm
    MOV AH, 09H
    INT 21H
    
    MOV AH,01H
    INT 21H
    
ENDM

.model small
.stack 32
.data

    msm db "Ingrese un valor (entre 0 y 8): $"
    ms2 db 10,13, "El resultado es: $"
    str db 6 dup('$')
.code
   
   
mov AX,@data;Segmento de datos
mov DS,AX;

Solicitar_Num

CMP AL, 30H
JE  CasoCero


SUB AL, 30H     ;Restamos 30 para que sea un numero y no un caracter


MOV CL, AL      ;La variable se pasa a CL para ser utilizada como contador
MOV AX, 1       ;Reestablecer el valor de ax para comenzar el factorial

CicloFactorial:
       
    CMP CL, 0
    JE  Conversion
    JA  Factorial
   
        
Factorial: 
    
    
    mul cx; Para el calculo del factorial, CX se multiplica con AX
    DEC CL
    JMP CicloFactorial
        
    
Conversion:

    call numeroAcadena ;Invocacion de convertir digito en cadena
    
    ;Mensaje y salto de linea para mejor escritura
      MOV DX, offset ms2
      MOV AH, 09H
      INT 21H
    
    ;Impresion en pantalla
      MOV  DX, offset str   
      MOV  AH, 09H
      INT  21H
    
Finalizar:

;Esperamos entrada del usuario
  mov  AH,7
  int  21H

;Finalizamos el programa.
  mov  AX, 4C00H
  int  21H           

;------------------------------------------

;El valor de la cadena debe estar en AX
;sayinin digitlerini teker teker cikarir
;Resta los digitos del numero, uno por uno
;Elimina los numeros de la pila y los inserta en la matriz

proc numeroAcadena
                        
  mov  BX, 10   ;Los numeros se restan dividiendo por 10, el 10 asignado a BX
  mov  CX, 0    ;El contrador esta configurado para los numeros restados
  
ciclo1:       
  mov  DX, 0    ;El valor en DX se reestablece, y DX se usa como apuntador
                ;El valor restante de esta seccion contendra el digito extraido
  div  BX       ;El valor en AX se divide por BX (10)
  push DX       ;DX se agrega a la pila de digitos
  inc  CX       ;El contador 'CX' se incrementa en 1
  cmp  AX, 0    ;El proceso continua hasta que AX = 0
  jne  ciclo1

  mov  si, offset str   ;Se asigna el valor a la cadena
  
ciclo2:  
  pop  DX        
  add  DL, 48       ;Los valores de la pila se eliminan uno por uno y se asignan a str
  mov  [ SI ], DL
  inc  SI
  loop ciclo2

  ret
endp


CasoCero:                   ;En caso de leer un cero

    MOV  DX, offset ms2     ;Mensaje de "resulado: "
    MOV  AH, 09H            
    INT  21H
    
    MOV  DX, 31H            ;Resultado caracter '1'
    MOV  AH, 02H
    INT  21H
    
    JMP Finalizar           ;Finalizamos el programa
    
    
    

end