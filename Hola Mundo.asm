.model small
.stack
.data
    ;Declaracion de variables
    presentacion db "Carreon Pulido Victor Hugo - 192310436", "$"
    salto db 10,13, "", "$"
    mensaje1 db 10,13, "Hola mundo!", "$"
    mensaje2 db 10,13, "Soy un programa de ensamblador  :)", "$"
.code
   principal:
    mov ax,@data ;Mover el contenido de data al registro ax
    mov ds,ax    ;Mover el contenido de ax al segmento de datos ds 
    
    mov ah,09h              ;Manda llamar la funcion 09h de 21h 
    lea dx, presentacion    ;Muestra mensaje mensaje            
    int 21h                 ;Interrupcion 21h                   
    lea dx, salto           ;Muestra mensaje mensaje
    int 21h                 ;Interrupcion 21h
    
    lea dx, mensaje1        ;Muestra mensaje mensaje
    int 21h                 ;Interrupción 21h
    
    lea dx, mensaje2        ;Muestra mensaje mensaje
    int 21h                 ;Interrupcion 21h    
 
    mov ah,1                ;Leer desde el teclado
    int 21h 
       
    mov ax,4c00h            ;Function (Salir del codigo)
    int 21h 
   end principal

ret