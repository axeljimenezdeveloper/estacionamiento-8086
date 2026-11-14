# Pseudocódigo — Cálculo de puestos del estacionamiento

## Entrada

- `eventos[]`: arreglo de bytes con valores `+1` (entrada) o `-1` (salida).
- `N`: cantidad de eventos en el arreglo.
- `CAPACIDAD`: constante = 20.

## Salida

- `puestos_ocupados`: byte en memoria (0–20).
- `puestos_disponibles`: byte en memoria (0–20).

## Algoritmo

```
Algoritmo CalcularPuestos
  ocupacion ← 0

  Para i desde 0 hasta N-1:
    evento ← eventos[i]

    Si evento = +1:                    // entrada
      Si ocupacion < CAPACIDAD:
        ocupacion ← ocupacion + 1
      // lleno: se ignora

    Si evento = -1:                    // salida
      Si ocupacion > 0:
        ocupacion ← ocupacion - 1
      // vacio: se ignora
  Fin Para

  puestos_ocupados    ← ocupacion
  puestos_disponibles ← CAPACIDAD - ocupacion
Fin Algoritmo
```

## Invariantes

1. `0 ≤ ocupacion ≤ 20` en todo momento.
2. `ocupacion + puestos_disponibles = 20` al final.
3. Cada evento se procesa exactamente una vez, en orden.