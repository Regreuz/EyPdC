section .text
    global string_reverse
    extern string_len

; void string_reverse(char *cadena)
string_reverse:
    push ebp
    mov ebp, esp
    push esi
    push edi

    mov esi, [ebp+8]          ; esi = inicio de la cadena

    push esi                  ; argumento para string_len
    call string_len
    add esp, 4                ; limpiar argumento (cdecl)

    ; eax = longitud
    cmp eax, 2
    jb .end                   ; longitud 0 o 1: nada que invertir

    lea edi, [esi+eax-1]      ; edi = último carácter

.loop:
    cmp esi, edi
    jae .end                  ; los punteros se cruzaron o se encontraron

    mov al, [esi]             ; intercambio
    mov ah, [edi]
    mov [esi], ah
    mov [edi], al

    inc esi
    dec edi
    jmp .loop

.end:
    pop edi
    pop esi
    pop ebp
    ret
