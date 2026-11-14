# Guía de ejecución — Explicación paso a paso

Explicación del flujo del programa `src/estacion.asm` desde el `MOV AX, @DATA` inicial hasta la escritura de resultados.

## 1. Inicialización del segmento de datos

```asm
inicio:
    MOV AX, @DATA
    MOV DS, AX
```

`@DATA` es el segmento donde vive el bloque `.DATA`. Sin cargar `DS`, cualquier `MOV AL, [variables]` leería basura de otro segmento. **Este par de instrucciones es obligatorio en todo programa `.MODEL SMALL`**.

## 2. Inicialización del recorrido

```asm
    LEA SI, eventos         ; SI = puntero al arreglo
    MOV CX, LONGITUD        ; CX = cantidad de eventos
    JCXZ .fin               ; si CX = 0, saltar al final
```

| Registro | Rol |
| :--- | :--- |
| `SI` (Source Index) | Puntero al elemento actual del arreglo. Se incrementa con `INC SI` por cada iteración. |
| `CX` (Counter) | Contador de iteraciones. `LOOP` lo decrementa automáticamente. |
| `JCXZ .fin` | **Crítico**: si `LONGITUD=0`, `LOOP` haría 65535 iteraciones (underflow). `JCXZ` salta al final cuando `CX=0`. |

## 3. Bucle principal — procesamiento de un evento

```asm
bucle:
    MOV AL, [SI]            ; cargar evento actual
```

`AL` recibe el byte del arreglo: `01h` (entrada) o `0FFh` (salida, i.e. `-1` en complemento a dos).

### 3.1 Intento de entrada

```asm
    CMP AL, 1
    JNE .check_salida       ; si no es entrada, evaluar salida
    CMP byte ptr ocupacion, CAPACIDAD
    JAE .siguiente          ; ya lleno → ignorar evento
    INC byte ptr ocupacion  ; incrementar ocupación
    JMP .siguiente
```

| Instrucción | Efecto |
| :--- | :--- |
| `CMP AL, 1` | ¿Es evento de entrada? |
| `CMP ocupacion, CAPACIDAD` | ¿Queda espacio? |
| `JAE .siguiente` | Si ocupación ≥ 20, se ignora (no se hace `INC`). |
| `INC byte ptr ocupacion` | Si hay espacio, incrementa en memoria. |

`byte ptr` es obligatorio: sin él, MASM no sabría si operar con 1 byte o 2 (ambigüedad con `DB`).

### 3.2 Intento de salida

```asm
.check_salida:
    CMP AL, 0FFh
    JNE .siguiente          ; si no es salida, ignorar
    CMP byte ptr ocupacion, 0
    JBE .siguiente          ; ya vacío → ignorar
    DEC byte ptr ocupacion  ; decrementar ocupación
```

| Instrucción | Efecto |
| :--- | :--- |
| `CMP AL, 0FFh` | ¿Es evento de salida? (`-1` = `0FFh` en complemento a dos). |
| `CMP ocupacion, 0` | ¿Hay autos? |
| `JBE .siguiente` | Si ocupación = 0, ignorar. |
| `DEC byte ptr ocupacion` | Decrementar si es válido. |

### 3.3 Avance

```asm
.siguiente:
    INC SI                  ; apuntar al siguiente evento
    LOOP bucle              ; CX-- ; si CX ≠ 0, volver
```

`LOOP` combina `DEC CX` + `JNZ bucle` en una sola instrucción de 2 bytes.

## 4. Resultados finales

```asm
.fin:
    MOV AL, ocupacion
    MOV puestos_ocupados, AL       ; ocupados = ocupación

    MOV AL, CAPACIDAD              ; 20
    SUB AL, ocupacion
    MOV puestos_disponibles, AL    ; disponibles = 20 - ocupados
```

Los resultados quedan en memoria (`puestos_ocupados`, `puestos_disponibles`), cumpliendo el requisito del TP.

## 5. Salida a stdout

```asm
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
```

Interrupción DOS `INT 21h` con `AH=40h` = **write to file handle**.

| Parámetro | Valor | Significado |
| :--- | :--- | :--- |
| `BX` | `1` | Handle 1 = `stdout` |
| `CX` | `1` | Escribir 1 byte |
| `DS:DX` | `&puestos_*` | Buffer de origen |

Escribe 2 bytes secuenciales: `[ocupados][disponibles]`. Esto permite `estacion.exe > result.bin` desde el shell DOS, y es lo que usa `scripts/test.ps1` para validar automáticamente los 8 casos.

## 6. Terminación

```asm
    MOV AH, 4Ch
    INT 21h
```

`INT 21h / AH=4Ch` = terminar programa y devolver control a DOS.

## 7. Traza de ejemplo

Con `eventos = 1, 1, -1, 1, -1, 1, 1, -1, 1, 1`:

| # | Evento | Ocupación | Acción |
| :---: | :---: | :---: | :--- |
| 1 | +1 | 0→1 | Entrada válida |
| 2 | +1 | 1→2 | Entrada válida |
| 3 | -1 | 2→1 | Salida válida |
| 4 | +1 | 1→2 | Entrada válida |
| 5 | -1 | 2→1 | Salida válida |
| 6 | +1 | 1→2 | Entrada válida |
| 7 | +1 | 2→3 | Entrada válida |
| 8 | -1 | 3→2 | Salida válida |
| 9 | +1 | 2→3 | Entrada válida |
| 10 | +1 | 3→4 | Entrada válida |

**Resultado final:** ocupados=4, disponibles=16.

Verificable bajo `DEBUG` con `d ds:0`: los bytes `04 04 10` deben aparecer secuencialmente.