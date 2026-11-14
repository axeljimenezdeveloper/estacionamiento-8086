; ==========================================
; hola.asm - Smoke test de la toolchain
; Verifica MASM + LINK + DOSBox funcionando
; ==========================================
.MODEL SMALL
.STACK 100h

.DATA
    mensaje DB 'Toolchain OK!', 13, 10, '$'

.CODE
inicio:
    MOV AX, @DATA
    MOV DS, AX

    MOV AH, 09h
    LEA DX, mensaje
    INT 21h

    MOV AH, 4Ch
    INT 21h
END inicio