bucle:
    MOV AL, [SI]            ; cargar evento actual

    ; ---- Intento de entrada (evento = 1) ----
    CMP AL, 1
    JNE .check_salida
    CMP byte ptr ocupacion, CAPACIDAD
    JAE .siguiente          ; ya lleno -> ignorar
    INC byte ptr ocupacion
    JMP .siguiente

    ; ---- Intento de salida (evento = -1 = 0FFh) ----
.check_salida:
    CMP AL, 0FFh
    JNE .siguiente
    CMP byte ptr ocupacion, 0
    JBE .siguiente          ; ya vacio -> ignorar
    DEC byte ptr ocupacion

.siguiente:
    INC SI
    LOOP bucle