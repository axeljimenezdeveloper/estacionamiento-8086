; ==========================================
; estacion.asm
; TP Microprocesadores (316) - Mod III - Und 7 - Obj 7
; Calcula puestos ocupados y disponibles en un estacionamiento
; ==========================================
.MODEL SMALL
.STACK 100h

.DATA
    CAPACIDAD           EQU 20

    ; Arreglo de eventos: 1 = entrada, -1 = salida
    eventos             DB  1, 1, -1, 1, -1, 1, 1, -1, 1, 1
    LONGITUD            EQU 10

    ocupacion           DB  0
    puestos_ocupados    DB  ?
    puestos_disponibles DB  ?

.CODE
inicio:
    MOV AX, @DATA
    MOV DS, AX

    ; ---- Inicializar recorrido ----
    LEA SI, eventos         ; SI = puntero al arreglo
    MOV CX, LONGITUD        ; CX = cantidad de eventos

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

    ; ---- Resultados finales ----
    MOV AL, ocupacion
    MOV puestos_ocupados, AL       ; ocupados = ocupacion

    MOV AL, CAPACIDAD
    SUB AL, ocupacion
    MOV puestos_disponibles, AL    ; disponibles = 20 - ocupacion

    MOV AH, 4Ch
    INT 21h
END inicio