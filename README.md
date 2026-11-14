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

- **DOSBox 0.74-3** (emulador de MS-DOS sobre Windows 10/11).
- **MASM 5.00** (ensamblador de Microsoft) y **LINK 3.60**.
- **PowerShell 5.1+** (para los scripts de automatización).
- **Node.js** (opcional, solo para usar `npm run` como task runner).

Instrucciones de instalación en [`CONTRIBUTING.md`](CONTRIBUTING.md).

## Estructura del repositorio

```text
estacionamiento-8086/
├── docs/
│   ├── pseudocode.md          # Algoritmo en pseudocódigo
│   ├── algorithm-design.md    # Análisis de casos límite y mapeo de registros
│   └── execution-guide.md     # Explicación paso a paso de la ejecución
├── src/
│   ├── estacion.asm           # Programa principal
│   ├── eventos.inc            # Arreglo parametrizable (sobrescrito por test.ps1)
│   └── hola.asm               # Smoke test de la toolchain
├── tests/
│   ├── test-cases.md          # Documentación de resultados
│   └── vectors/
│       └── case-01..08.inc    # 8 vectores de prueba
├── scripts/
│   ├── build.ps1              # Compila + enlaza
│   ├── test.ps1               # Runner automatizado de casos
│   ├── clean.ps1              # Limpia artefactos
│   └── lib.ps1                # Helper compartido
├── build/                     # Artefactos generados (ignorado)
├── package.json               # Task runner
├── .editorconfig
├── .gitattributes
├── .gitignore
├── CHANGELOG.md
├── CONTRIBUTING.md
├── LICENSE
└── README.md
```

## Comandos disponibles

```powershell
npm run build   # Ensambla y enlaza src/estacion.asm
npm run test    # Ejecuta los 8 casos de prueba automatizados
npm run clean   # Limpia binarios, logs y resultados de test
```

## Cómo ejecutar

### Compilar

```powershell
npm run build
```

Genera `estacion.exe` en la raíz del proyecto. Logs en `build/masm.log` y `build/link.log`.

### Ejecutar el programa

Desde DOSBox manualmente:

```
mount c "C:\ruta\a\estacionamiento-8086"
c:
estacion.exe
```

El programa escribe los 2 bytes de resultado (`[ocupados][disponibles]`) a `stdout`. Para verlos formateados, ejecuta bajo `DEBUG`:

```
d:\debug.exe estacion.exe
-u
-g
-d ds:0
-q
```

O redirige a un archivo:

```
estacion.exe > resultado.bin
```

### Ejecutar los tests

```powershell
npm run test
```

Compila y ejecuta los 8 casos automatizados. Resultado esperado: `8 PASS / 0 FAIL`.

## Estado del proyecto

- [x] Fase 0 — Bootstrap del repositorio
- [x] Fase 1 — Configuración del entorno
- [x] Fase 2 — Diseño del algoritmo (docs-first)
- [x] Fase 3 — Implementación incremental
- [x] Fase 4 — Pruebas y verificación (8/8 PASS)
- [x] Fase 5 — Documentación final y release

## Documentación adicional

- [Pseudocódigo](docs/pseudocode.md)
- [Análisis de diseño](docs/algorithm-design.md)
- [Guía de ejecución](docs/execution-guide.md)
- [Casos de prueba](tests/test-cases.md)
- [Guía de contribución](CONTRIBUTING.md)
- [Changelog](CHANGELOG.md)

## Licencia

Distribuido bajo licencia MIT. Ver [`LICENSE`](LICENSE).