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
    valor db ?
    str db 6 dup('$')
.code
   
   
mov ax,@data;Segmento de datos
mov ds,ax;

Solicitar_Num

CMP AL, 30h
JE  CasoCero


SUB al, 30H
mov valor, al

MOV CL, valor ;La variable se pasa a CL para ser utilizada como contador
mov ax,1;Reestablecer el valor de ax para comenzar el factorial
 
Factorial: 


mul cx; Para el calculo del factorial, CX se multiplica con AX

loop Factorial ;


call numeroAcadena ;Invocacion de convertir digito en cadena

;Mensaje y salto de linea para mejor escritura
  mov  dx, offset ms2
  mov  ah, 09h
  int  21h

;Impresion en pantalla
  mov  dx, offset str   
  mov  ah, 09h
  int  21h

Finalizar:

;Esperamos entrada del usuario
  mov  ah,7
  int  21h

;Finalizamos el programa.
  mov  ax, 4c00h
  int  21h           

;------------------------------------------

;El valor de la cadena debe estar en AX
;sayinin digitlerini teker teker cikarir
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


CasoCero:

    mov  dx, offset ms2
    mov  ah, 09h
    int  21h
    
    mov  dx, 31h
    mov  ah, 02h
    int  21h
    
    jmp Finalizar
    
    
    

end