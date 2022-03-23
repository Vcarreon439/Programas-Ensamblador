MACRO COLOREAR esqsup,esqinf, col
    mov ax,0600h
    mov cx, esqsup
    mov dx, esqinf
    mov bh, col
    int 10h   
ENDM

org 100h
.data
    msg db ' Carreon Pulido Victor Hugo - 192310436',13,10,' Bandera de Ucrania',"$"
    
.code
    .startup

    COLOREAR 00h, 184fh, 0e0h
    COLOREAR 0000h, 094fh, 97H
    
    mov dx, offset msg
    mov ah,9
    int 21h
 
    mov ax,0C07h
    int 21h 
    
end