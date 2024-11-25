.686
.model flat

public _dylatacja_czasu
.data
c_speed dd 300000000  ; prêdkoœæ œwiat³a (c)

.code
_dylatacja_czasu PROC
    ; Prolog funkcji
    push ebp
    mov ebp, esp

    finit ; Inicjalizacja koprocesora

    ; Obliczenie v^2/c^2
    fld dword ptr [ebp + 12]    ; Wartoœæ predkosc v
    fmul st(0), st(0)           ; Obliczenie v^2
    fild dword ptr [c_speed]     ; Wczytanie c do rejestru FPU
    fmul st(0), st(0)           ; c^2
    fdivp                        ; v^2/c^2 - st(0)

    ; Obliczenie 1 - v^2/c^2
    fld1                   ; Wczytanie 1 - st(0)
    fsub st(0), st(1)              ; 1 - v^2/c^2

    ; Obliczenie pierwiastka
    fsqrt                  ; sqrt(1 - v^2/c^2) - st(0)

    ; Obliczenie delta_t_zero / sqrt(1 - v^2/c^2)
    fild dword PTR [ebp + 8]   ; Wczytanie delta_t_zero (unsigned int) - st(0)
    fdiv st(0), st(1)           ; delta_t_zero / sqrt(1 - v^2/c^2)

    pop ebp
    ret
_dylatacja_czasu ENDP
END
