section .text
    global int_to_string
    extern string_reverse

; eax = número con signo, [ebp+8] = buffer destino
int_to_string:
    push ebp
    mov ebp, esp
    push esi
    push edi

    mov edi, [ebp+8]          ; edi = puntero de escritura

    cmp eax, 0
    jge .digits
    mov byte [edi], '-'
    inc edi                   ; los dígitos empiezan después del signo
    neg eax

.digits:
    mov esi, edi              ; esi = inicio de los dígitos (para invertir)
    mov ecx, 10

.loop:
    xor edx, edx
    div ecx                   ; eax = cociente, edx = residuo
    add dl, '0'
    mov [edi], dl
    inc edi
    test eax, eax
    jnz .loop

    mov byte [edi], 0         ; terminador

    push esi                  ; invertir solo los dígitos
    call string_reverse
    add esp, 4

    pop edi
    pop esi
    pop ebp
    ret
