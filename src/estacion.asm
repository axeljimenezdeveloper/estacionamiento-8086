inicio:
    MOV AX, @DATA
    MOV DS, AX

    ; ---- Inicializar recorrido ----
    LEA SI, eventos         ; SI = puntero al arreglo
    MOV CX, LONGITUD        ; CX = cantidad de eventos

bucle:
    MOV AL, [SI]            ; cargar evento actual
    ; (logica de validacion en commit 3)
    INC SI
    LOOP bucle

    MOV AH, 4Ch
    INT 21h
END inicio