; ==========================================
; estacion.asm
; TP Microprocesadores (316) - Mod III - Und 7 - Obj 7
; Calcula puestos ocupados y disponibles en un estacionamiento
; Capacidad maxima: 20 puestos
; ==========================================
.MODEL SMALL
.STACK 100h

.DATA
    CAPACIDAD           EQU 20

    ; ---- Arreglo de eventos ----
    ; 1 = entrada, -1 = salida (0FFh en complemento a dos)
    ; Este bloque es reemplazado por scripts/test.ps1 en cada caso de prueba
    eventos             DB  1, 1, -1, 1, -1, 1, 1, -1, 1, 1
    LONGITUD            EQU 10

    ; ---- Estado y resultados ----
    ocupacion           DB  0
    puestos_ocupados    DB  ?
    puestos_disponibles DB  ?

    ; ---- Mensajes de salida ----
    msg_ocu             DB  'OCUPADOS: ', '$'
    msg_dis             DB  13, 10, 'DISPONIBLES: ', '$'
    msg_fin             DB  13, 10, '$'

.CODE
inicio:
    MOV AX, @DATA
    MOV DS, AX

    ; ---- Inicializar recorrido ----
    LEA SI, eventos         ; SI = puntero al arreglo
    MOV CX, LONGITUD        ; CX = cantidad de eventos
    JCXZ .fin               ; si CX = 0, saltar al final

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

.fin:
    ; ---- Resultados finales ----
    MOV AL, ocupacion
    MOV puestos_ocupados, AL       ; ocupados = ocupacion

    MOV AL, CAPACIDAD
    SUB AL, ocupacion
    MOV puestos_disponibles, AL    ; disponibles = 20 - ocupacion

    ; ---- Escribir 2 bytes binarios a stdout (para test automatizado) ----
    ; Permite 'estacion.exe > result.bin'. El runner lee estos 2 bytes.
    MOV AH, 40h
    MOV BX, 1
    MOV CX, 1
    LEA DX, puestos_ocupados
    INT 21h

    MOV AH, 40h
    MOV BX, 1
    MOV CX, 1
    LEA DX, puestos_disponibles
    INT 21h

    ; ---- Salida legible para el usuario ----
    LEA DX, msg_ocu
    MOV AH, 09h
    INT 21h

    MOV AL, puestos_ocupados
    CALL print_al

    LEA DX, msg_dis
    MOV AH, 09h
    INT 21h

    MOV AL, puestos_disponibles
    CALL print_al

    LEA DX, msg_fin
    MOV AH, 09h
    INT 21h

    ; ---- Terminar ----
    MOV AH, 4Ch
    INT 21h

; ==========================================
; Rutina: imprimir AL como decimal (0-99)
; Entrada: AL = numero a imprimir
; Salida:  texto en stdout
; Preserva: todos los registros
; ==========================================
print_al:
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX

    XOR AH, AH
    MOV BL, 10
    DIV BL                  ; AL = decena, AH = unidad
    MOV CX, AX              ; CL = decena, CH = unidad

    TEST CL, CL
    JZ .imprimir_unidad     ; si decena = 0, solo unidad

    MOV DL, CL
    ADD DL, '0'
    MOV AH, 02h
    INT 21h

.imprimir_unidad:
    MOV DL, CH
    ADD DL, '0'
    MOV AH, 02h
    INT 21h

    POP DX
    POP CX
    POP BX
    POP AX
    RET

END inicio