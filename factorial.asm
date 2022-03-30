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
valor db ?
str db 6 dup('$') 
.code
   
   
mov ax,@data;data segmenintinin yerini ax e atiyoruz
mov ds,ax;

Solicitar_Num
SUB al, 30h
mov valor, al

MOV CL, valor


;mov cl,degisken;tanimlanan degisken cl ye aktariliyor sayac olarak kullanilmak icin 

mov ax,1;ax in degeri isleme baslamaka icin sifirlaniyor
 
 
fakt: 


mul cx; faktoriyerl hesabi yapmak icin cx teki deger ax registeriyle carpiliyor 

loop fakt ;


call number2string  ;rakami stringe donusturme fonksiyonunu cagirir

;ekrana yazdirma fonksiyonu
  mov  ah, 9
  mov  dx, offset str   
  int  21h

;islem bittikten sonra kullanicidan key bekler
  mov  ah,7
  int  21h

;programi kapatir.
  mov  ax, 4c00h
  int  21h           

;------------------------------------------

;stringe donusecek deger ax te bulunmalidir
;sayinin digitlerini teker teker cikarir
;ve sayilari stackte saklar 
;sayilari stackten cikarip diziye atar

proc number2string
  mov  bx, 10 ;sayilar 10 a bolunerek cikarilir bx registerine 10 atarnir 
  mov  cx, 0 ;cikarilan sayilar icin sayac ayarlanir
cycle1:       
  mov  dx, 0 ;dx teki deger sifirlanir, dx reminder olarak kullanilir 
             ;bu bolumden kalan deger cikarilan digiti tutacak
  div  bx ;ax teki deger bx e bolunur ax/10
  push dx ;dx teki digit stacke eklenecek  
  inc  cx ;cx teki sayac degeri 1 arttirilir
  cmp  ax, 0  ;ax teki deger 0 olana kadar islem devam eder
  jne  cycle1 ; 

  mov  si, offset str ;degeri stringe atamaya baslaniyor
cycle2:  
  pop  dx        
  add  dl, 48 ;degerler teker teker stackten cikarilip str degiskenine ataniyor
  mov  [ si ], dl
  inc  si
  loop cycle2  

  ret
endp  

end