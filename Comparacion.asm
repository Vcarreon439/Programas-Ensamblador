;Carreon Pulido Victor Hugo - 192310436

.model small
.stack
.data

   var1 db ?
   var2 db ?      
   pres db 'Carreon Pulido Victor Hugo - 192310436$'
   msg1 db ' > $'
   msg2 db ' < $'
   espa db 10,13, '$'
   msg3 db ' = $'
   msg4 db 10,13, 'Ingrese el primer valor: $'
   msg5 db 10,13, 'Ingrese el segundo valor: $'

.code
.startup
  
   ;Se presenta la informacion del estudiante
   mov ah,09h
   lea dx,pres
   int 21h
   
   ;Se muestra "Ingrese primer valor: "
   mov ah,09h
   lea dx,msg4
   int 21h
   
   ;Se lee la entrada en teclado
   mov ah,07h
   int 21h
      
   mov ah, 02h
   mov dl,al
   int 21h
   mov  var1,al
   
   ;Se muestra "Ingrese segundo valor: "
   mov ah,09h
   lea dx,msg5
   int 21h
   
   ;Se lee la entrada en teclado
   mov ah,07h
   int 21h

   mov ah,02h
   mov dl,al
   int 21h
   mov var2,al
  
  ;Se mueven las variables
  mov al, var1 
  mov bl, var2
  mov ah,al
  
  ;Se realiza la comparacion
  cmp var1,bl
  ja mayor
  jb menor
  je igual

mayor:

;Se hace un salto
   mov ah,09h
   lea dx,espa
   int 21h
    
    ;Mostrar numero 1
    mov al,var1
    mov ah,02h
    mov dl,al
    int 21h 

    ;Mostrar simbolo
    mov ah,09h
    lea dx,msg1
    int 21h
    
    ;Mostrar numero 2
    mov al,var2
    mov ah,02h
    mov dl,al
    int 21h 
   
   jmp salir

menor:


;Se hace un salto
   mov ah,09h
   lea dx,espa
   int 21h
    
    ;Mostrar numero 1
    mov al,var1
    mov ah,02h
    mov dl,al
    int 21h 

    ;Mostrar simbolo
    mov ah,09h
    lea dx,msg2
    int 21h
    
    ;Mostrar numero 2
    mov al,var2
    mov ah,02h
    mov dl,al
    int 21h 
   
   ;Salir del programa
   jmp salir

igual:

   ;Se hace un salto
   mov ah,09h
   lea dx,espa
   int 21h
    
    ;Mostrar numero 1
    mov al,var1
    mov ah,02h
    mov dl,al
    int 21h 

    ;Mostrar simbolo
    mov ah,09h
    lea dx,msg3
    int 21h
    
    ;Mostrar numero 2
    mov al,var2
    mov ah,02h
    mov dl,al
    int 21h 
   
   jmp salir


salir:

  .exit
   end