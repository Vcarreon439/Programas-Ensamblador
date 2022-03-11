; Autor: Victor Hugo Carreon Pulido - 192310436

org 100h

.model small
.stack
.data

    numero1 db ?
    numero2 db ?
    Rsuma    db 0
    Rresta   db 0
    
    pres db 13,10, "Carreon Pulido Victor Hugo - 192310436$"
    espa db 13,10, "$"
    
    mensaje0 db "CALCULADORA$"
    mensaje1 db 13,10, "Ingrese el primer numero: $"
    mensaje2 db 13,10, "Ingrese el segundo numero: $"
    mensaje3 db 13,10, "SUMA = $"
    mensaje4 db 13,10, "RESTA = $"    
    mensaje5 db 13,10, "MULTIPLICACION = $"    
    mensaje6 db 13,10, "DIVISION = $"
    mensaje7 db 13,10, "RESIDUO = $"
    
.code     

   inicio:
    mov ax,@data 
    mov ds,ax    

    ;Mensaje de presentacion
    mov ah,09h      
    lea dx,mensaje0 
    int 21h
    
    ;Titulo del programa         
    mov ah,09h      
    lea dx,pres
    int 21h         
    
    
    mov ah,09h      
    lea dx,espa 
    int 21h

    ;Muestra "Ingrese el primer numero: "
    mov ah,09h      
    lea dx,mensaje1 
    int 21h
    
    ;Se lee la entrada en teclado            
    mov ah,07h
    int 21h
    
    mov ah, 02h
    mov dl, al
    int 21h
    ;Se guarda en una variable
    sub al,30h
    mov numero1,al
    
    
    ;Se muestra "Ingrese el segundo numero: "
    mov ah,09h      
    lea dx,mensaje2 
    int 21h
             
    ;Se lee la entrada en teclado
    mov ah, 07h
    int 21h
    
    mov ah,02h
    mov dl, al
    int 21h   
    ;Se guarda en una variable
    sub al,30h
    mov numero2, al
    
    ;Brincamos a suma
    jmp suma
    
suma:

    mov ah,09h      
    lea dx,espa 
    int 21h
     
    ;Mostramos el mensaje "Suma = "
    mov ah,09
    lea dx,mensaje3
    int 21h
    
    ;Realizamos la operacion
    mov al, numero1
    mov bl, numero2
    add al, bl
    mov Rsuma, al
    mov al,Rsuma
    
    ;Separamos en caso de tener un resultado mayor a 2 digitos
    aam
    mov bx, ax
   
    ;Imprimimos el primer digito    
    add bh, 30h
    mov dl, bh
    mov ah, 02
    int 21h
    
    ;Imprimimos el segundo digito
    add bl, 30h
    mov dl, bl
    mov ah, 02
    int 21h
    
    ;Brincamos a resta
    jmp resta
    
        
resta:
    
    ;Mostramos el mensaje de "Resta = "
    mov ah,09
    lea dx,mensaje4
    int 21h
    
    ;Realizamos una comparacion para saber si el resultado sera negativo
    mov bl, numero2
    cmp numero1,bl
       
    ;Brincos segun el resultado de la comparacion
    ja mayor
    jb menor
    je mayor


mayor:
    
    ;En caso de ser mayor, el flujo de la resta es el esperado
    mov al,numero1
    mov bl,numero2
    sub al,bl
    mov Rresta,al
    
    ;Imprimimos el resultado de la resta    
    mov dl,Rresta
    add dl,30h
    mov ah,02
    int 21h
    
    ;Brincamos a multiplicacion
    jmp multiplicacion
    
    
menor:

    ;En caso de ser menor, imprimimos primero el signo negativo
    mov ah,02
    mov dl,45
    int 21h
    
    ;Realizamos la resta de manera inversa siendo esta
    ;(NumMayor) - (NumMenor)
    mov al,numero2
    mov bl,numero1
    sub al,bl
    mov Rresta,al
    
    ;Imprimirmos el digito resultante de la resta inversa        
    mov dl,Rresta
    add dl,30h
    mov ah,02
    int 21h
    
    ;Brincamos a multiplicacion
    jmp multiplicacion
    
    
multiplicacion: 
    
    ;Mostramos "Multiplicacion = "
    mov ah,09
    lea dx,mensaje5
    int 21h
    
    ;Realizamos la multiplicacion
    ;multiplica al=al*bl
    mov al,numero1
    mov bl,numero2
    mul bl
    
    ;Separamos en caso de ser un resultado mayor a 2 digitos  
    aam
    mov bx,ax
    
    ;Muestra el resultado
    
    ;Muestra el primer digito
    add bh, 30h
    mov dl, bh
    mov ah, 02
    int 21h
    
    ;Muestra el segundo digito
    add bl, 30h
    mov dl, bl
    mov ah, 02
    int 21h
                
    ;Brincamos a multiplicacion               
    jmp division
    
division:
    
    ;Mostramos mensaje "Division = "
    mov ah,09
    lea dx,mensaje6  
    int 21h
    
    ;Limpiar reistro ax
    xor ax,ax 
    
    ;Realizamos la division
    ;El resultado se guarda en al, divide al=al/bl
    mov al,numero1
    mov bl,numero2
    div bl     
    mov bl,al
    mov dl,bl
    
    ;Guardamos el residuo
    mov bh, ah
    
    ;Imprimirmos el resultado de la division
    add dl,30h
    mov ah,02
    int 21h
    
    ;Mostramos mensaje "Residuo = "
    mov ah,09
    lea dx, mensaje7
    int 21h
    
    ;Imprimimos el residuo de la division
    mov dl,bh
    add dl, 30h
    mov ah,02
    int 21h
    
    ;Funcion para terminar el codigo
    mov ax,4c00h
    int 21h  
    
   end 
   

ret
