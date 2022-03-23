include 'emu8086.inc'
ejercicio5 macro esqsup,esqinf, col
    mov ax,0600h
    mov cx, esqsup
    mov dx, esqinf
    mov bh, col
    int 10h
    
    
       
    endm                                                       

org 100h

    ejercicio5 00h, 184fh, 0e0h
    ejercicio5 0000h, 094fh, 11H
 
    mov ax,0C07h
    int 21h


ret