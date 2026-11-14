# Diseño del algoritmo — Análisis técnico

## 1. Casos límite

| # | Escenario | Entrada | Ocupados | Disponibles |
| :--- | :--- | :--- | :---: | :---: |
| 1 | Arreglo vacío | `[]` | 0 | 20 |
| 2 | Solo entradas (25) | `[+1]*25` | 20 | 0 |
| 3 | Solo salidas (5) | `[-1]*5` | 0 | 20 |
| 4 | Lleno + entrada extra | 20 entradas + 1 | 20 | 0 |
| 5 | Vacío + salida extra | 1 salida | 0 | 20 |
| 6 | Mixto válido | `[+1, +1, -1, +1]` | 2 | 18 |
| 7 | Mixto con violaciones | `[-1, +1*21, -1, +1]` | 20 | 0 |
| 8 | Alternado | `[+1, -1, +1, -1, +1]` | 1 | 19 |

Los casos 2, 3, 4 y 5 validan las condiciones de saturación.

## 2. Codificación del arreglo

- **Entrada**: byte `01h`.
- **Salida**: byte `0FFh` (= -1 en complemento a dos).

## 3. Mapeo a registros y memoria del 8086

| Registro | Uso |
| :--- | :--- |
| `SI` | Puntero al arreglo de eventos |
| `CX` | Contador del bucle (`LOOP`) |
| `DS` | Segmento de datos |
| `AL` | Evento actual leído desde `[SI]` |
| `BL` | Temporal para comparaciones |

| Variable | Tipo | Uso |
| :--- | :--- | :--- |
| `eventos` | `DB` | Arreglo de eventos |
| `CAPACIDAD` | `EQU 20` | Constante de capacidad |
| `ocupacion` | `DB 0` | Estado durante el bucle |
| `puestos_ocupados` | `DB ?` | Resultado final |
| `puestos_disponibles` | `DB ?` | Resultado final |

## 4. Estructura del bucle principal

```
LEA SI, eventos           ; SI = inicio del arreglo
MOV CX, LONGITUD          ; CX = número de eventos

bucle:
    MOV AL, [SI]          ; cargar evento
    CMP AL, 1
    JNE .check_salida
    ; lógica de entrada
    JMP .siguiente
.check_salida:
    CMP AL, 0FFh
    JNE .siguiente
    ; lógica de salida
.siguiente:
    INC SI
    LOOP bucle
```

## 5. Justificación de decisiones

- **`LOOP` sobre `DEC CX` + `JNZ`**: instrucción de 2 bytes que decrementa y salta.
- **`SI` como puntero**: convención 8086 para arrays, permite `[SI]` sin desplazamiento.
- **Estado en memoria (`ocupacion`)**: el enunciado exige que los resultados queden en memoria. Facilita depuración con `DEBUG` (`D DS:0000`).
- **`CMP` + saltos (`JAE`, `JBE`, `JE`)**: no contamina el estado antes de decidir si el evento es válido.