section .text
    global print_int
    extern int_to_string
    extern print_str

print_int:
    push ebp
    mov ebp, esp
    sub esp, 12 ; buffer local: [ebp-12] .. [ebp-1]

    mov eax, [ebp+8] ; número
    lea edx, [ebp-12] ; inicio del buffer

    push edx
    call int_to_string
    add esp, 4

    lea edx, [ebp-12] ; recalcular, edx pudo cambiar
    push edx
    call print_str
    add esp, 4

    mov esp, ebp
    pop ebp
    ret
