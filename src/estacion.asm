; ==========================================
; estacion.asm
; TP Microprocesadores (316) - Mod III - Und 7 - Obj 7
; Calcula puestos ocupados y disponibles en un estacionamiento
; ==========================================
.MODEL SMALL
.STACK 100h

.DATA
    CAPACIDAD           EQU 20

    ; Arreglo de eventos (definido en src\eventos.inc, sobrescrito por test.ps1)
    INCLUDE src\eventos.inc

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

    ; ---- Volcar resultados a stdout (2 bytes binarios) ----
    ; Permite 'estacion.exe > resultado.bin' desde el shell DOS.
    ; Bytes: [puestos_ocupados][puestos_disponibles]
    MOV AH, 40h                    ; DOS write to file handle
    MOV BX, 1                      ; handle 1 = stdout
    MOV CX, 1                      ; 1 byte
    LEA DX, puestos_ocupados
    INT 21h

    MOV AH, 40h
    MOV BX, 1
    MOV CX, 1
    LEA DX, puestos_disponibles
    INT 21h

    MOV AH, 4Ch
    INT 21h
END inicio