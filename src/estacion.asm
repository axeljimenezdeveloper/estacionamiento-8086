; ==========================================
; estacionamiento.asm
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

    ; (Logica del algoritmo se agrega en commits posteriores)

    MOV AH, 4Ch
    INT 21h
END inicio