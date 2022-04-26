MACRO CONFIGURAR  
    
      MOV AX,0600H ;Limpiar pantalla... AL = 00H limpia todos los renglones
      MOV BH,5BH   ;Color de fondo y Letra
      MOV CX,0000H ;esquina sup.izquierda de la pantalla(0,0)
      MOV DX,184FH ;esquina inf. derecha de la pantalla(24,79)
      INT 10H
      
      MOV AH,02H 
      MOV DX,00H   ;posiscion del cursor(0,0) despues de limpiar pantalla
      MOV BH,00H   ;Pagina 0
      INT 10H
    
ENDM


MACRO FLUSH
    ;Limpia los espacios de memoria
    mov AX,0
    mov CX,0
    mov BX,0
    mov DX,0
    
    mov sum,0
    mov fsum,0
    mov counter,0
    mov bandera_1,0
    mov bandera_2,0
    
ENDM

;Calculadora de 2 numeros enteros de 5 digitos


;Macro para imprimir mensaje
Imprimir macro p1
    mov ah,9
    mov dx,offset p1
    int 21h
endm


.model small
.stack 100h
.data

;Variables

msg1 db 'Carreon Pulido Victor Hugo - 192310436'

db 13,10,13,10,'Seleccione una opcion...'
db 13,10,'1. Suma'
db 13,10,'2. Resta'
db 13,10,'3. Multiplicacion'
db 13,10,'4. Division'
db 13,10,'ESC. Salir'
db 13,10,13,10,'Tu eleccion: $'

msg2 db 13,10,'Ingrese el primer numero: $'
msg3 db 13,10,'Ingrese el segundo numero: $'
msg4 db 13,10,13,10,'Resultado: $'

msg5 db 13,10,13,10,'Error de division - el denominador es 0 $'

;Banderas 1 y 2 iniciadas en 0 
;para el primer y segundo numero cuando los ingrese el usuario
bandera_1 db 0
bandera_2 db 0

;Contador de digitos
counter dw 0
;Primer y segundo numero, almacenando el resultado en sum
sum dw 0
;El primer numero completo se almacena en fsum
fsum dw 0
;Multiplica el valor anterior con 10
mulBy10 dw 10
;mod para el valor a imprimir de la division al finalizar
;Iniciado en 10K para los 5 digitos
mod dw 10000 

;Almacena el valor del operador cualquiera desde 1 a 4 basado en la entrada del usuario
opcion db '$'

.code

proc main
 
  mov ax,@data
  mov ds,ax
 
iniciar:

  configurar 
  
  ;imprime el menu
  Imprimir msg1
    
    ;Interrupcion para leer pantalla  
    mov ah,1
    int 21h  
    
    ;Se inicia la comparacion desde aqui
    ; 27 o ESC para salir del programa
    cmp al,27
    je end
    
    ;Chequeo del operador
    cmp al,'1'
    je Suma
    
    cmp al,'2'
    je Resta
    
    cmp al,'3'
    je Multiplicar
   
    cmp al,'4'
    je Dividir
    
    ;Si es algo mas reiniciar el programa
    jmp iniciar 
    
    ;Realiza la operacion segun la entrada moves input value by checking for which accordingly to op
    Suma:
    mov opcion,1 
    jmp iniciar_2 
    
    Resta:
    mov opcion,2 
    jmp iniciar_2
    
    Multiplicar:
    mov opcion,3 
    jmp iniciar_2
    
    Dividir:
    mov opcion,4
   
    
  ;La lectura de los numeros empieza desde aqui
  iniciar_2:
  mov cx,2     
        
inp:

    ;Si CX es 2, se voltea para el primer numero
    ;Imprimirmos el primer numero 
    cmp cx,2
    je  printmsg1
    
    ;En caso contrario para el segundo
    Imprimir msg3
    jmp input
    
    printmsg1:
    Imprimir msg2
    
        
        
  input:
  
    mov ah,1
    int 21h
    
    ;Toma la entrada de un digito a la vez y lo compara
    ; Si presiona enter, se saltara 
    cmp al,13
    je resume_2
    
    ;Si es ESC regresar el menu
    cmp al,27
    je retry
    
    ; if neg input then sets flag
    ; of whichever number's turn it is
     cmp al,'-'
     jne check_further
     
    ; '-' sign should be input at first digit only
     cmp counter,0
     jne again_input
        
     cmp cx,2
     je set_bandera_1
     
     mov bandera_2,1  
    
     jmp input
     set_bandera_1:
     
     mov bandera_1,1
     
     jmp input
     
     
     
     
     
    check_further: 
        
    ; Verifica que los numeros se encuentren entre 0 y 9
    cmp al,48
    jb again_input
    
    cmp al,57
    jg again_input
    
    
    
    jmp resume
    
    ;Si el usuarios se equivoca 
    ;reimprime el mensaje y vuelve a solicitar
    ;el numero
    again_input:
    mov dl,8
    mov ah,2
    int 21h
    jmp input
    
     
    resume:
          
    mov ah,0
    sub al,48
    
    ;Mueve la entrada a BX
    ;Libera Ax
    mov bx,ax
   
   ;Comprueba si el valor anterior fue 10
   ; then no need to mul by 10 to raise place
    cmp sum,0
    je resume_1
    mov ax,sum
    mul mulBy10
    mov sum,ax 
resume_1:    
    
   ; after mul by 10 means
   ; if user inputs 123 previously 
   ; and now he enters 4 - so mul 123 by 10
   ; to make in 1230 then add 4 in it
   ; so then it becomes 1234  
   add sum,bx
    

    
     inc counter
     
     ; see if counter is 5 means 5 igits dare entered
     ;if not then keep asking for input
     cmp counter,5
     jne input
    
    resume_2:
     
        cmp cx,2
        je store_first_number
        
        jmp resume_3 
        store_first_number:
        
        
        mov bx,sum
        mov fsum,bx
        mov sum,0
        mov counter,0
   
    resume_3:
     
     ;Loop para el segundo numero
     loop inp
     
     ;Mueve el primero completo a BX
     mov bx,fsum 
      
        ;Checa si es division y brinca a division
         cmp opcion,4
         je division
    
    
     
            ; here it checks for
            ;if user pressed - for
            ;number then take 2's complement
         

           cmp bandera_1,1
     jne check_further_2
     
     
     ; if first is neg then
     ; take 2's complement
     do_neg_1:
     neg bx
     
     
     check_further_2:
     
     cmp bandera_2,1
     jne resume_4
     
     
     ;Si el segundo es negativo entonces
     ;toma el segudo completo
      neg sum
        
     
     ;Checa que tipo de calculo se realizara
     resume_4:
     
     cmp opcion,1
     je addition
     
     cmp opcion,2
     je subtraction
     
     cmp opcion,3
     je multiplication
     
     jmp division
     
    
     addition:
     
     add bx,sum
     mov sum,bx
     jmp resume_5
     
     subtraction:
     sub bx,sum
     mov sum,bx
     jmp resume_5
     
     
     multiplication:
     mov ax,bx
     
     imul sum
     
     mov sum,ax
     
     jmp resume_5

division:

        ;Verifica si el denominador es 0 y si es asi imprime el mensajer de error
        cmp sum,0
        jne resume_div 
        
        Imprimir msg5
        
        mov ah,1
        int 21h  
        
        jmp iniciar
        ;En caso contrario resume la division
        resume_div:
        mov dx,0
        mov ax,bx
                
        mov bx,sum
        
        idiv bx
        
        mov sum,ax
        
        ;Verifica si la division
        ; seperate fro other 3
        ; due to resons having difficult
        ; calculating mod and printing values
        ; with same code as other 3
        
        ;Imprimer el mensaje de resultado
        Imprimir msg4
        
        ;Verifica los signos
        
        cmp bandera_1,1
        je neg_div_check
        
        
        cmp bandera_2,1
        je print_neg_div
        
        jmp calc_mod_for_div
       

neg_div_check:
     
        cmp bandera_2,1
        jne print_neg_div
        
          jmp calc_mod_for_div
         
        print_neg_div:
        mov dl,'-'
        mov ah,2
        int 21h

calc_mod_for_div:     
    
    resume_5:    
        
        cmp opcion,4
        je resume_6
        
        Imprimir msg4
        
    ;Aqui se calcula el valor chechando el
    ;rngo de resultados
    resume_6:  
    
        cmp sum,10
        jb make_mod_1
        
        cmp sum,100
        jb make_mod_10
        
        cmp sum,1000
        jb make_mod_100
        
        cmp sum,10000
        jb make_mod_1000
        
        cmp sum,10000
        jge make_mod_10000
        
        ;Separacion para los numero negativos
        cmp sum,-10
        jg make_mod_1_Resta
        
        cmp sum,-100
        jg make_mod_10_Resta
        
        cmp sum,-1000
        jg make_mod_100_Resta
        
        cmp sum,-10000
        jg make_mod_1000_Resta
        
        cmp sum,-10000
        jbe make_mod_10000_Resta
      

    make_mod_1:
    
        mov mod,1
        mov counter,1
        jmp check_negative
    
    make_mod_10:
    
        mov mod,10
        mov counter,2
        jmp check_negative
    
    make_mod_100:
    
        mov mod,100
        mov counter,3
        jmp check_negative
      
    make_mod_1000:
    
        mov mod,1000
        mov counter,4 
        jmp check_negative

    make_mod_10000:   
    
        mov mod,10000
        mov counter,5 
        cmp opcion,3
        jmp check_negative
       
      make_mod_1_Resta:
      mov mod,1
      mov counter,1
      jmp  check_negative
      
      make_mod_10_Resta:
      mov mod,10
       mov counter,2
      jmp  check_negative
     
      
      make_mod_100_Resta:
       mov mod,100
       mov counter,3
      jmp  check_negative
     
      make_mod_1000_Resta:
       mov mod,1000
        mov counter,4 
      
      make_mod_10000_Resta:
       mov mod,10000
        mov counter,5 
      
      
        
;Checa si es negativo
;De esta manera se determina si se imprime el simbolo negativo
 check_negative:
           
        ;Si el valor es 32768, este es el maximo de los negativos
        ;y para el positivo es  65,535
        ;Si lo toma como negativo entonces se invrtiran los numeros
        ;y positivo si llega hasta 65,535
         
        cmp opcion,3
        jne check_2
        
        cmp opcion,2
        je Resta_adjust
        
        cmp bandera_1,1
        je check_flag_2
        
        cmp bandera_2,1
        je  check_pos_mul
        
        jmp print
        
        check_flag_2:
        cmp bandera_2,1
        je print
        
        check_pos_mul:
        neg sum
        cmp sum,-1
        jbe print_neg         
          
        check_2:
        cmp sum,32768
        jb check_further_neg 
        
        cmp bandera_1,1
        je do_neg_sum
        
        cmp bandera_2,1
        jne check_further_neg
        
        do_neg_sum:
        neg sum
        
        jmp print_neg
          

check_further_neg:
        
        cmp opcion,1
        je print
        
        cmp opcion,4
        je print
        
        check_neg: 
        cmp sum,-1
        js Resta_adjust
        jmp print
        Resta_adjust:
        
        neg sum
  
 
print_neg:

        mov dl,'-'
        mov ah,2
        int 21h       
       
;Imprime el resultado en pantalla
;Por ejemplo si el numero es de 4 digitos entonces el multiplicador incial
;sera 1000   
    
; Dividirs it by mod it gives ax = 1 and dx = 234 - store dx back to sum
; takes ax - mov to dx - add 48 - finally print
; does this same until counter reaches 0 - as it dec's counter at each print
print:
    
        mov ax,sum
        mov dx,0
        
        mov bx,mod
        div bx
        
        mov sum,dx
        
        mov dx,ax
        add dx,48
        mov ah,2
        int 21h
        
        mov dx,0
        mov ax,mod
        
        mov bx,10
        
        div bx
      
        mov mod,ax
        
        
        dec counter
        
        cmp counter,0
        jne print
       
;Limpia los registros
retry: 
       
       FLUSH
       
       mov ah,1
       int 21h
       
       jmp iniciar
         
end:
         
        mov ah,4ch
        int 21h


endp main
end main
