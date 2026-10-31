section .data 
    msg_error_1 db "Error en los argumentos", 0
    len_msg1 equ $ -msg_error_1
    msg_error_2 db "Error apertura", 0
    len_msg2 equ $ -msg_error_2

    msg_lineas db "Lineas: ", 0
    msg_words db "Palabras: ", 0
    msg_chars db "Letras: ", 0

section .bss
    buffer resb 1

section .text
    global _start
    extern print_str   
    extern print_int

_start:
    mov eax, [esp]
    cmp eax, 2
    jl .error_args

    mov ebx, [esp+8]
    mov eax, 5
    mov ecx, 0
    int 0x80

    test eax, eax
    js .error_open

    ;Vamos incializando
    mov esi, eax
    xor ecx, ecx ;Para las lineas
    xor edx, edx ;Para las palabras
    xor edi, edi ;Para los caracteres o letras
    xor ebp, ebp ;Bandera para palabras

.read_loop:
    ;Ciclo de lectura
    mov eax, 3
    mov ebx, esi
    mov ecx, buffer
    mov edx, 1
    int 0x80

    ;Se pudo abrir?
    cmp eax, 0
    js .error_open
    jz .done

    inc edi ;Incremento en los caracteres
    mov al, [buffer]
    cmp al, 10  ;Caracter '\n'
    jne .check_space
    inc ecx ;lineas++

.check_space:
    cmp al, ' '
    je .space
    cmp al, 9 ;Es un tab?
    je .space
    cmp al, 10 ; Es una nueva linea?
    je .space

    cmp ebp, 0
    jne .continue
    inc edx ;Incremento de palabra
    mov ebp, 1
    jmp .continue

.space:
    mov ebp, 0

.continue:
    jmp .read_loop

.done:
    ;Cierre
    mov eax, 6
    mov ebx, esi
    int 0x80

    ;Impresion lineas
    push msg_lineas
    call print_str
    add esp, 4

    push ecx
    call print_int
    add esp,4

    ;Palabras
    push msg_words
    call print_str
    add esp, 4

    push edx
    call print_int
    add esp, 4

    ;caracteres
    push msg_chars
    call print_str
    add esp, 4

    push edi
    call print_int
    add esp, 4

    jmp .fin

.error_args:
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_error_1
    mov edx, len_msg1
    int 0x80

    jmp .fin

.error_open:
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_error_2
    mov edx, len_msg2
    int 0x80
    
    jmp .fin

.fin:
    mov eax, 1
    xor ebx, ebx
    int 0x80
