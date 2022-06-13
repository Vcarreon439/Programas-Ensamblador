data segment
menu db 'Carreon Pulido Victor Hugo - 192310436',13,10,13,10,'**** Menu ****',13,10,' (1) Ingresar Datos',13,10,' (2) Ver Datos Ingresados',13,10,' (3) Ordenar los Datos Ingresados',13,10,' (4) Salir',13,10,13,10,'Elija una Opcion:$'
pkey db 13,10,'Introduce 10 Numeros a Ordenar: ',13,10, '$'
msjerror db 13,10,'Se Esperaba un Numero del 0...9, Continue Desde el Ultimo Digito: ',13,10,'$'
msjenter db 13,10,'Presiona Enter para Regresar: $'
msjao db 13,10,'Datos Ordenados: ',13,10,'$'
msjmenu db 13,10,'Opcion no Valida, Elije Segun el Menu ',13,10,' $'
salto db 13,10,'',13,10,'$'
array db 10 dup(0)
parche db ' $'
ends

;aqui se declara la pila esto lo hace el emu8086 por default
stack segment
dw 128 dup(0)
ends

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
  
;declaracion del segmento de codigo, despues de esta declaracion viene el codigo q necesitara el programa
code segment

start: ;en esta etiqueta lo unico que haremos sera desplegar el menu
Configurar
mov ax, data;pasamos lo que hay en el segmento de datos al registro ax
mov ds, ax ;pasamos lo que hay en el registro ax al segmento de datos(ds)
mov es, ax ;pasamos lo que hay en el registro ax al segmento extra(es)

;en esta parte desplegaremos el contenido de la variable menu
lea dx, menu; esto es equivalente a mov dx,offset menu
mov ah, 9 ;utilizamos el servicio 9
int 21h ;de la interrupcion 21h la cual nos permite desplegar en pantalla

lee_opcion: ;esta etiqueta se encargara de checar la opcion que el usuario eligio

mov ah,1 ;utilizamos el servicio 1
int 21h ;de la interrupcion 21h que nos permite introducir una tecla
;esta interrupcion guarda la tecla que preionamos en al

cmp al,31h ;en esta parte comparamos lo que hay en al(osea la tecla que metimos) con 1(31h en hexadecimal)
jb errormenu ; si introducimos un numero menor que 1 nos enviara a la etiqueta errormenu
je meter_datos;pero si es igual osea si metimos 1 nos enviara a la etiqueta meter_datos
cmp al,32h;en esta parte comparamos lo que hay en al(osea la tecla que metimos) con 2(32h en hexadecimal)
je imprimir_array; si metimos un 2 nos enviara a la etiqueta imprimir_array
cmp al,33h ;en esta parte comparamos lo que hay en al(osea la tecla que metimos) con 3(33h en hexadecimal)
je ordena ;si metimimos un 3 nos enviara a la etiqueta ordena
cmp al,34h ;;en esta parte comparamos lo que hay en al(osea la tecla que metimos) con 4(34h en hexadecimal)
ja errormenu ; esta parte checa si el numero que metimos es mayor que 4, de ser asi nos manda a la eiqueta errormenu
je salir ;de lo contrario si lo que metimos es un 4 nos mandara a la etiqueta salir

;esta etiqueta se encarga de meter datos, cuando el usuario mete un 1 el programa salta a esta parte
meter_datos:
call limpiar ;mandamos a llamar a la etiqueta limpiar
Configurar
lea dx, pkey ;aqui pasamos el contenido de la variable pkey al registro dx
mov ah, 9 ;puesto que el servicio 9 de la interrupcion 21h requiere que lo que
int 21h ; se va a desplegar en pantalla este en el registro dx por esa razon es que pkey se envia a dx

mov si,0 ;aqui ponemos el indice de nuestro arreglo en 0

;la etiqueta validacion se encargara de que metamos solo numeros de lo contrario mandara un mensaje de error
validacion:

mov ah, 1;utilizamos nuevamente el servicio 1 de la
int 21h ;interrucpion 21h para meter los datos

;como necesitamos mover el contenido de al a cx, pero cx es de 16 bits y al de 8 bits
mov cx,ax ;entonces agarramos a ax, y asi mlo movemos a cx

cmp al, 30h ; comparamos lo que metimos con 0
jb error ; si es menor que 0 entonces enviamos um mensaje de error
cmp al, 39h ; comparamos lo que metimos con 9
ja error ; si es mayor que 9 entonces enviamos un mensaje de error

mov array[si],cl ;pasamos lo que metimos a nuestro arreglo

lea dx, parche ;aqui pasamos el contenido de la variable parche al registro dx
mov ah, 9 ;puesto que el servicio 9 de la interrupcion 21h requiere que lo que
int 21h ;esto nos servira para dar espacio entre cada numero que metamos

add si, 1 ;incrementamos nuestro indice en uno para que nos movamos en el arreglo

;si[[0][0+1=1][1+1=2][2+1=3][3+1=4][4+1=5][5+1=6][6+1=7][7+1=8][8+1=9][9+1=10]]
cmp si,0ah ;comparamos si nuestro indice(SI) ya llego a 10

jb validacion; si todavia no ha llegado a 10, osea si es menor que salte a validacion
;y segumios metiendo numeros hasta que se completen los 10
mov si,0 ;ponemos nuestro indice en la posicion cero
call limpiar ;mandamos a la etiqueta limpiar
jmp start;saltamos a la etiqueta start

;esta etiqueta se encargara de imprimir el arreglo
imprimir_array:
call limpiar ;mandamos a llamr a la etiqueta limpiar
Configurar
;en esta parte se hara un salto de linea

mov dx, offset salto
mov ah, 9
int 21h

lea dx, array[si] ;aqui imprimos el arreglo
mov ah, 9 ;como es el servicio 9 pasamos array al registro dx
int 21h

;aqui imprimimos el emnsaje que contiene la variable msjenter
mov dx, offset msjenter
mov ah, 9
int 21h

ir_menu:
mov ah,1 ;pedimos un enter para regresar con el servicio 1
int 21h ;de la in terrupcion 21h

cmp al,0Dh ;comparamos lo que metimos con 0dh (enter)
jb ir_menu ;si es menor volvemos a ir_menu y pedimos de nuevo un enter
ja ir_menu ;si es mayor volvemos a ir_menu y pedimos de nuevo un enter


call limpiar ;llamamos a limpiar
jmp start;luego saltamos a la etiquta start


;esta parte se encarga de ordenar el arreglo
ordena:
mov si,0 ;poenmos nuestro indice a cero
mov cx,9 ; y en el registro cx ponemos 9 que nos servira para el primer ciclo loop

cicloi:
push cx;guardamos el valor que pusimos en cx en la pila
mov cx,9 ; luego volvemos a poner 9 en cx lo que nos servira para el segundo ciclo loop
mov si, offset array ; ponemos los valores que estan guardados en nuestro arreglo en si
mov di,si ;luego pasamos si a di
cicloj:
inc di ;incrementamos en uno a di, es decir, di=di+1
mov al,[si] ;luego lo que esta es si lo pasamos a al registro al
cmp al,[di] ; luego hacemos la comparacion
ja intercambio;si el numero que hay en al es mayor que el que hay di saltamos a la etiqueta intercambio
jmp imasi ; de lo contrario saltamos a imasi
intercambio: ;aqui hacemos el intercambio de valores
mov ah,[di] ;lo que hay en di lo pasamos a ah(ah funicona como una variable auxiliar)
mov [di],al;luego lo que hay en al se pasa a di
mov [si],ah ;y lo que hay en ah lo pasamos a si
imasi:;en esta etiqueta solo incrementamos a si en uno es decir si=si +1
inc si
loop cicloj ;el segundo ciclo se repite hasta que cx llega a cero
pop cx ;aqui sacamos el valor que guardamos en el registro cx
loop cicloi ;el ciclo se repite hasta que el cx del primer ciclo llega a cero
;es decir el cs que almacenamos en la pila

mov si,0;volvemos a poner nuestro indice a cero
call limpiar ;llamamos alimpiar
jmp start;saltamos a la etiqueta start

;en esta etiqueta desplegamos un mensaje de error para el menu
errormenu:
call limpiar ;llamamos a limpiar
mov dx, offset msjmenu ;pasamos el contenido de la variable msjmenu
mov ah, 9 ;al registro dx y con el servicio 9 de la interrupcion
int 21h ;21h desplegamos el mensaje

jmp start ;aqui saltamos a la etiqueta start

;desplegamos un mensaje de error para indicar de que no introdujo un numero
error:
mov dx, offset msjerror ;pasamos el contenido de la variable msjerror
mov ah, 9 ;al registro dx y con el servicio 9 de la interrupcion
int 21h ;21h desplegamos el mensaje

jmp validacion ;aqui saltamos a la etiqueta validacion

;esta etiqueta nos servira para limpiar pantalla
limpiar:
mov ah,00h ;usamos el servico 00h de la interrupcion 10h
mov al,03h ;para limpiar la pantalla
int 10h

ret


;aqui salimos del programa
salir:
mov ax, 4c00h;utilizamos el servicio 4c de la interrupcion 21h
int 21h ;para termianr el programa
ends

end start