# Estacionamiento 8086 — TP Microprocesadores (316)

Programa en **lenguaje ensamblador** para el microprocesador **8086/8088** que calcula la cantidad de puestos disponibles en un estacionamiento a partir de un arreglo de eventos (`+1` = entrada, `-1` = salida) almacenado en memoria.

## Contexto académico

| Campo | Valor |
| :--- | :--- |
| Materia | Microprocesadores (316) |
| Módulo | III — Unidad 7 — Objetivo 7 |
| Tipo | Trabajo Práctico (TP) |

## Objetivo

Recorrer secuencialmente un arreglo de eventos en memoria y calcular:

1. **Puestos ocupados** — ocupación actual del estacionamiento.
2. **Puestos disponibles** — `CAPACIDAD - ocupados`.

Ambos resultados quedan almacenados en memoria al finalizar la ejecución.

## Reglas de negocio

- Capacidad máxima: **20 puestos**.
- Ocupación inicial: **0 vehículos**.
- Intento de salida con ocupación `0` → se **ignora**.
- Intento de entrada con ocupación `20` → se **ignora**.

## Requisitos

- DOSBox (para emular MS-DOS sobre Windows 10/11).
- MASM 6.11 o TASM.
- (Alternativa) emu8086.

Ver [`CONTRIBUTING.md`](CONTRIBUTING.md) para instalación detallada y convenciones.

## Estructura del repositorio

```text
estacionamiento-8086/
├── docs/                  # Pseudocódigo, diseño, guía de ejecución
├── src/                   # Código fuente ensamblador
├── tests/                 # Casos de prueba y vectores
├── scripts/               # Utilidades PowerShell
├── build/                 # Scripts de compilación
├── package.json           # Task runner (npm scripts)
├── .editorconfig
├── .gitignore
├── CHANGELOG.md
├── CONTRIBUTING.md
├── LICENSE
└── README.md
```

## Comandos disponibles

```powershell
npm run build   # Ensambla y enlaza src/estacionamiento.asm (Fase 1)
npm run test    # Ejecuta los vectores de prueba (Fase 4)
npm run clean   # Limpia binarios generados
```

## Estado del proyecto

- [x] Fase 0 — Bootstrap del repositorio
- [ ] Fase 1 — Configuración del entorno
- [ ] Fase 2 — Diseño del algoritmo (docs-first)
- [ ] Fase 3 — Implementación incremental
- [ ] Fase 4 — Pruebas y verificación
- [ ] Fase 5 — Documentación final y release
- [ ] Fase 6 — CI con GitHub Actions (opcional)

## Licencia

Distribuido bajo licencia MIT. Ver [`LICENSE`](LICENSE).