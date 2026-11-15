# Changelog

Todos los cambios notables de este proyecto se documentan en este archivo.

El formato se basa en [Keep a Changelog](https://keepachangelog.com/es-ES/1.1.0/)
y este proyecto se adhiere a [Semantic Versioning](https://semver.org/lang/es/).

## [1.0.1] - 2026-11-15

### Added

- Salida legible en pantalla: `OCUPADOS: N` y `DISPONIBLES: M` vía `INT 21h/AH=09h` + `INT 21h/AH=02h`, cumpliendo el requisito "mostrar" del enunciado.
- Rutina `print_al` que convierte un byte (0-99) a su representación decimal en pantalla.

### Changed

- `src/estacion.asm` ahora es **autocontenido**: el arreglo `eventos` está inline en lugar de `INCLUDE src\eventos.inc`. Compila standalone en cualquier emu8086/MASM/DOSBox sin dependencias externas.
- `scripts/test.ps1` sustituye el bloque `eventos DB ...` y `LONGITUD EQU N` por regex en lugar de sobrescribir un `.inc` auxiliar. Tolerante a indentación.

### Removed

- `src/eventos.inc` (ya no se usa tras eliminar `INCLUDE`).

### Fixed

- El programa no mostraba resultados legibles al ejecutarse sin redirección, lo que podría interpretarse como incumplimiento del requisito "mostrar" del instructivo del TP.
- Regex del runner no matcheaba por indentación y `LABEL BYTE` no era soportado en el caso vacío.

## [1.0.0] - 2026-11-14

### Added

- Programa `src/estacion.asm` que calcula puestos ocupados y disponibles en un estacionamiento de capacidad 20, con validación de saturación superior e inferior.
- Arreglo de eventos parametrizable vía `src/eventos.inc` con `INCLUDE`.
- Guard `JCXZ` para arreglos vacíos (`LONGITUD=0`).
- Salida binaria a `stdout` (`INT 21h/AH=40h`) con los 2 bytes de resultado.
- Runner automatizado `scripts/test.ps1` que compila, ejecuta y valida los 8 casos de prueba.
- 8 vectores de prueba en `tests/vectors/` cubriendo casos límite (arreglo vacío, lleno, violaciones, alternado).
- Documentación de pseudocódigo (`docs/pseudocode.md`) y análisis técnico (`docs/algorithm-design.md`).
- Guía de ejecución paso a paso (`docs/execution-guide.md`).
- Documentación de resultados de pruebas (`tests/test-cases.md`).
- Script `scripts/build.ps1` con generación dinámica de `dosbox.conf` y `compile.bat`.
- Script `scripts/clean.ps1` que limpia binarios de la raíz y de `build/`.

### Changed

- Toolchain migrada de `MASM 6.11` a `MASM 5.00` (compatible con el paquete `shiburaj/masm-dos`).
- Scripts de automatización migrados de `Start-Process` con `-c` a generación de archivos `.conf`/`.bat` (evita el bug de escape de backslashes en DOSBox 0.74).
- Convención de nombres 8.3 aplicada a todos los archivos que MASM/LINK leen o escriben.

### Fixed

- `LOOP` con `CX=0` ejecutaba 65535 iteraciones por underflow → resuelto con `JCXZ`.
- Nombres largos (`estacionamiento.asm`, `resultado.bin`) truncados a 8.3 por DOS → renombrados a `estacion.asm`, `result.bin`.
- `.gitignore` inicial no cubría artefactos generados (`*.log`, `*.bat`, `*.conf`, `*.bin`, `*.BIN`) → ampliado.

### Removed

- Script `scripts/bootstrap/run-all.ps1` y sub-scripts (reemplazados por archivos individuales reescribibles).
- Versión preliminar que usaba `DEBUG.EXE` con redirección de I/O (no soportada por el shell DOS).

[1.0.1]: https://github.com/axeljimenezdeveloper/estacionamiento-8086/releases/tag/v1.0.1
[1.0.0]: https://github.com/axeljimenezdeveloper/estacionamiento-8086/releases/tag/v1.0.0