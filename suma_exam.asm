section .data
    msg         db "Ingresa un numero del 0 al 9: "
    msg_len     equ $ - msg

    msg_error   db "Error: fuera de los limites", 10
    msg_err_len equ $ - msg_error

    msg_result  db "El resultado de la suma es: "
    msg_res_len equ $ - msg_result

    salto       db 10

section .bss
    buffer      resb 32
    resultado   resb 4

section .text
    global _start

_start:
    ; Imprime el mensaje
    mov eax, 4
    mov ebx, 1
    mov ecx, msg
    mov edx, msg_len
    int 0x80

    ;Recaba el primer numero
    mov eax, 3
    mov ebx, 0
    mov ecx, buffer
    mov edx, 32
    int 0x80

    ;Lo evalua para ver si esta en el rango
    mov edi, eax                
    cmp edi, 1
    jb  .error
    mov al, [buffer]
    cmp al, '0'
    jb  .error
    cmp al, '9'
    ja  .error
    
    ;Exactamente un digito?
    cmp edi, 1
    je  .ok1
    cmp byte [buffer+1], 10
    je  .ok1
    cmp byte [buffer+1], 13
    je  .ok1
    jmp .error

; Conversion simple y ajuste de bits
.ok1:
    sub al, '0'
    movzx esi, al

    ;Vuelve a mandar la instruccion
    mov eax, 4
    mov ebx, 1
    mov ecx, msg
    mov edx, msg_len
    int 0x80

    ;Lo recaba
    mov eax, 3
    mov ebx, 0
    mov ecx, buffer
    mov edx, 32
    int 0x80

    ;Lo evalua en el rango
    mov edi, eax
    cmp edi, 1
    jb  .error
    mov al, [buffer]
    cmp al, '0'
    jb  .error
    cmp al, '9'
    ja  .error

    ;Exacamente un digito?
    cmp edi, 1
    je  .ok2
    cmp byte [buffer+1], 10
    je  .ok2
    cmp byte [buffer+1], 13
    je  .ok2
    jmp .error

.ok2:
    sub al, '0'
    movzx ebx, al

    ;Ya superados los filtors, sumar
    add ebx, esi                
    mov edi, ebx

    ;Mensaje que indica el resultado
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_result
    mov edx, msg_res_len
    int 0x80

    ;Cambiar de cadena a decimal
    mov eax, edi
    mov ecx, resultado
    xor edx, edx
    mov ebx, 10
    div ebx                     

    test eax, eax
    jz   .un_digito

    ;Caso donde hubo dos digitos como resultado
    add al, '0'
    mov [ecx], al
    add dl, '0'
    mov [ecx+1], dl
    mov byte [ecx+2], 0
    mov edx, 2
    jmp .imprimir

;Caso de un solo digito
.un_digito:
    add dl, '0'
    mov [ecx], dl
    mov byte [ecx+1], 0
    mov edx, 1

.imprimir:
    ;Impresion del resultado
    mov eax, 4
    mov ebx, 1
    mov ecx, resultado
    int 0x80

    ;Salto de linea para que no se vea mal
    mov eax, 4
    mov ebx, 1
    mov ecx, salto
    mov edx, 1
    int 0x80

    jmp .final

.error:
    ;Impresion del mensaje de error
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_error
    mov edx, msg_err_len
    int 0x80

.final:
    mov eax, 1
    xor ebx, ebx
    int 0x80
