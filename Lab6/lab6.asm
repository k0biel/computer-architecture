; Program gwiazdki.asm
; Wyświetlanie znaków * w takt przerwań zegarowych
; Uruchomienie w trybie rzeczywistym procesora x86
; lub na maszynie wirtualnej
; zakończenie programu po naciśnięciu klawisza 'x'
; asemblacja (MASM 4.0): masm gwiazdki.asm,,,;
; konsolidacja (LINK 3.60): link gwiazdki.obj;
.386
rozkazy SEGMENT use16
ASSUME CS:rozkazy

klawisze PROC
push ax
in al,60H

cmp al,4bh
je strzalka_lewo 

cmp al,4dh
je strzalka_prawo 

cmp al,48h
je strzalka_gora 

cmp al,50h
je strzalka_dol
jmp koniec

strzalka_gora:
mov cs:kierunek, 0
jmp koniec

strzalka_lewo :
mov cs:kierunek, 1
jmp koniec

strzalka_dol:
mov cs:kierunek,2
jmp koniec

strzalka_prawo :
mov cs:kierunek, 3
jmp koniec
	
koniec:
pop ax
jmp dword ptr cs:vec9
vec9 dd ?
klawisze ENDP

;============================================================
; procedura obsługi przerwania zegarowego
obsluga_zegara PROC
; przechowanie używanych rejestrów
push ax
push bx
push es
; wpisanie adresu pamięci ekranu do rejestru ES - pamięć
; ekranu dla trybu tekstowego zaczyna się od adresu B8000H,
; jednak do rejestru ES wpisujemy wartość B800H,
; bo w trakcie obliczenia adresu procesor każdorazowo mnoży
; zawartość rejestru ES przez 16
mov ax, 0B800h ;adres pamięci ekranu
mov es, ax
; zmienna 'licznik' zawiera adres bieżący w pamięci ekranu
mov bx, cs:licznik
; przesłanie do pamięci ekranu kodu ASCII wyświetlanego znaku
; i kodu koloru: biały na czarnym tle (do następnego bajtu)
; zwiększenie o adresu bieżącego w pamięci ekranu
cmp cs:kierunek,0
je gora
cmp cs:kierunek,1
je lewo
cmp cs:kierunek,2
je dol
cmp cs:kierunek,3
je prawo

gora:
mov byte PTR es:[bx], 5Eh 
mov byte PTR es:[bx+1], 00000111B 
sub bx,160	
jmp dalej

lewo:
mov byte PTR es:[bx], 3Ch 
mov byte PTR es:[bx+1], 00000111B 
sub bx,2	
jmp dalej

dol:
mov byte PTR es:[bx], 76h 
mov byte PTR es:[bx+1], 00000111B 
add bx,160	
jmp dalej

prawo:
mov byte PTR es:[bx], 3Eh 
mov byte PTR es:[bx+1], 00000111B 
add bx,2
dalej:
; sprawdzenie czy adres bieżący osiągnął koniec pamięci ekranu
cmp bx,4000
jb wysw_dalej ; skok gdy nie koniec ekranu
; wyzerowanie adresu bieżącego, gdy cały ekran zapisany
mov bx, 0
;zapisanie adresu bieżącego do zmiennej 'licznik'
wysw_dalej:
mov cs:licznik,bx
; odtworzenie rejestrów
pop es
pop bx
pop ax
; skok do oryginalnej procedury obsługi przerwania zegarowego
jmp dword PTR cs:wektor8
; dane programu ze względu na specyfikę obsługi przerwań
; umieszczone są w segmencie kodu
licznik dw 320 ; wyświetlanie począwszy od 2. wiersza
wektor8 dd ?
kierunek db 3
obsluga_zegara ENDP
;============================================================
; program główny - instalacja i deinstalacja procedury
; obsługi przerwań
; ustalenie strony nr 0 dla trybu tekstowego
zacznij:
mov al, 0
mov ah, 5
int 10
mov ax, 0
mov ds,ax ; zerowanie rejestru DS
; odczytanie zawartości wektora nr 8 i zapisanie go
; w zmiennej 'wektor8' (wektor nr 8 zajmuje w pamięci 4 bajty
; począwszy od adresu fizycznego 8 * 4 = 32)
mov eax,ds:[32] ; adres fizyczny 0*16 + 32 = 32
mov cs:wektor8, eax
; odczytanie zawartości wektora nr 9
mov eax,ds:[36] 
mov cs:vec9, eax
; wpisanie do wektora nr 8 i 9 adresu procedury 'obsluga_zegara'
mov ax, SEG obsluga_zegara ; część segmentowa adresu
mov bx, OFFSET obsluga_zegara ; offset adresu
mov dx, SEG klawisze
mov cx, OFFSET klawisze
cli ; zablokowanie przerwań
; zapisanie adresu procedury do wektora nr 8
mov ds:[32], bx ; OFFSET
mov ds:[34], ax ; cz. segmentowa
; zapisanie adresu procedury do wektora nr 9
mov ds:[36], cx
mov ds:[38], dx
sti ;odblokowanie przerwań
; oczekiwanie na naciśnięcie klawisza 'x'
aktywne_oczekiwanie:
mov ah,1
int 16H
; funkcja INT 16H (AH=1) BIOSu ustawia ZF=1 jeśli
; naciśnięto jakiś klawisz
jz aktywne_oczekiwanie
; odczytanie kodu ASCII naciśniętego klawisza (INT 16H, AH=0)
; do rejestru AL
mov ah, 0
int 16H
cmp al, 'x' ; porównanie z kodem litery 'x'
jne aktywne_oczekiwanie ; skok, gdy inny znak
; deinstalacja procedury obsługi przerwania zegarowego
; odtworzenie oryginalnej zawartości wektora nr 8
mov eax, cs:wektor8
cli
mov ds:[32], eax ; przesłanie wartości oryginalnej
; do wektora 8 w tablicy wektorów
; przerwań
sti
mov eax, cs:vec9
cli
mov ds:[36], eax
sti
; zakończenie programu
mov al, 0
mov ah, 4CH
int 21H
rozkazy ENDS
nasz_stos SEGMENT stack
db 128 dup (?)
nasz_stos ENDS
END zacznij