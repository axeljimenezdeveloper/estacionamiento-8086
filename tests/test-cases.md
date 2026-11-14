# Casos de prueba — Resultados de ejecución

Ejecución automatizada vía `npm run test`, que recorre los 8 vectores en `tests/vectors/`.

**Resultado global:** ✅ **8 PASS / 0 FAIL**

## Vectores

| # | Archivo | Descripción | Entrada | Ocupados | Disponibles | Estado |
| :--- | :--- | :--- | :--- | :---: | :---: | :---: |
| 1 | `case-01-empty.inc` | Arreglo vacío | `[]` | 0 | 20 | ✅ PASS |
| 2 | `case-02-full-entries.inc` | Solo entradas (25) | `[+1]*25` | 20 | 0 | ✅ PASS |
| 3 | `case-03-only-exits.inc` | Solo salidas (5) | `[-1]*5` | 0 | 20 | ✅ PASS |
| 4 | `case-04-full-plus-entry.inc` | Lleno + entrada extra | 20 entradas + 1 | 20 | 0 | ✅ PASS |
| 5 | `case-05-empty-plus-exit.inc` | Vacío + salida extra | 1 salida | 0 | 20 | ✅ PASS |
| 6 | `case-06-mixed-valid.inc` | Mixto válido | `[+1, +1, -1, +1]` | 2 | 18 | ✅ PASS |
| 7 | `case-07-mixed-violations.inc` | Mixto con violaciones | `[-1, +1*21, -1, +1]` | 20 | 0 | ✅ PASS |
| 8 | `case-08-alternated.inc` | Alternado | `[+1, -1, +1, -1, +1]` | 1 | 19 | ✅ PASS |

## Cómo se ejecutó

Cada vector es un `.inc` con el arreglo `eventos` y `LONGITUD`, más comentarios parseables:

```asm
; EXPECT_OCUPADOS = 20
; EXPECT_DISPONIBLES = 0
eventos     DB  1, 1, 1, ...
LONGITUD    EQU 21
```

`scripts/test.ps1` para cada vector:

1. Copia el `.inc` a `src/eventos.inc`.
2. Compila con MASM y LINK (en DOSBox, vía `build/run-test.bat`).
3. Ejecuta `estacion.exe > build\result.bin` (redirección de stdout).
4. Lee los **2 bytes** del resultado: `[puestos_ocupados][puestos_disponibles]`.
5. Compara con las expectativas y reporta PASS/FAIL.
6. Restaura `src/eventos.inc` al estado original.

El programa `estacion.asm` escribe los resultados a stdout con `INT 21h, AH=40h` (DOS write to handle), lo que permite automatización sin depender de `DEBUG`.

## Verificación complementaria con DEBUG

Además de los tests automatizados, se verificó manualmente con `DEBUG.EXE` que el bloque `.fin:` produce el desensamblado esperado (`MOV AL,[ocupacion]`, `SUB AL,[ocupacion]`, etc.) y que los bytes en memoria coinciden con los resultados obtenidos por stdout.

## Reproducir

```powershell
npm run clean
npm run build
npm run test
```