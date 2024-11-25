.686
.model flat

public _fibonacci

.code
push ebp
    mov ebp, esp
    push ebx
    push ecx

    movzx ebx, byte [ebp+8]   ; Odczytanie k z pami�ci

    cmp ebx, 47               ; Gdy k > 47
    ja return_negative        

    cmp ebx, 1                ; Gdy k = 1 lub 2
    jbe fib_return_1

    mov ecx, 2                ; Ustaw licznik na 2 (indeks)

fib_loop:
    mov eax, 1                ; Pierwszy element
    mov edx, 1                ; Drugi element

    cmp ecx, ebx              ; Sprawd�, czy osi�gni�to indeks k
    je fib_done

    add eax, edx              ; Suma dw�ch poprzednich element�w
    mov edx, eax              ; Przesu� wynik do edx

    inc ecx                   ; Inkrementuj licznik indeksu
    jmp fib_loop              ; Powt�rz p�tl�

fib_return_1:
    mov eax, 1                ; Je�li k = 1 lub 2, zwr�� 1jmp fib_exit
    jmp fib_exit

fib_done:
    mov eax, edx              ; Wynik znajduje si� w edx
    jmp fib_exit

return_negative:
    mov eax, -1               ; Zwr�� -1 w przypadku k > 47

fib_exit:
    pop ecx
    pop ebx
    pop ebp
    ret

_szukaj_max	ENDP
END