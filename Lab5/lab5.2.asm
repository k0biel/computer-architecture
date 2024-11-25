.686
.XMM
.model flat

public _szybki_max

.code
_szybki_max PROC
    push ebp
    mov ebp, esp

    push ebx
    push esi
    push edi

    mov ebx, [ebp + 8]       ; Adres t_1
    mov esi, [ebp + 12]      ; Adres t_2
    mov edi, [ebp + 16]      ; Adres t_wynik
    mov ecx, [ebp + 20]      ; Wartoœæ n (liczba elementów w tablicy)

    mov eax, 0               
    next:
        movups xmm0, [ebx]
		movups xmm1, [esi]
		pmaxsw xmm0 ,xmm1

        movups [edi], xmm0

        add ebx,16
		add esi,16
		add edi,16
        add eax, 8
        cmp eax, ecx
    jb next

    pop edi
    pop esi
    pop ebx

    mov esp, ebp
    pop ebp
    ret
_szybki_max ENDP
END