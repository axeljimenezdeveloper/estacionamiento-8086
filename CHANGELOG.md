# Changelog

Todos los cambios notables de este proyecto se documentan en este archivo.

El formato se basa en [Keep a Changelog](https://keepachangelog.com/es-ES/1.1.0/)
y este proyecto se adhiere a [Semantic Versioning](https://semver.org/lang/es/).

## [1.0.0] - 2026-11-14

### Added

- Programa `src/estacion.asm` que calcula puestos ocupados y disponibles en un estacionamiento de capacidad 20, con validaciÃ³n de saturaciÃ³n superior e inferior.
- Arreglo de eventos parametrizable vÃ­a `src/eventos.inc` con `INCLUDE`.
- Guard `JCXZ` para arreglos vacÃ­os (`LONGITUD=0`).
- Salida binaria a `stdout` (`INT 21h/AH=40h`) con los 2 bytes de resultado.
- Runner automatizado `scripts/test.ps1` que compila, ejecuta y valida los 8 casos de prueba.
- 8 vectores de prueba en `tests/vectors/` cubriendo casos lÃ­mite (arreglo vacÃ­o, lleno, violaciones, alternado).
- DocumentaciÃ³n de pseudocÃ³digo (`docs/pseudocode.md`) y anÃ¡lisis tÃ©cnico (`docs/algorithm-design.md`).
- GuÃ­a de ejecuciÃ³n paso a paso (`docs/execution-guide.md`).
- DocumentaciÃ³n de resultados de pruebas (`tests/test-cases.md`).
- Script `scripts/build.ps1` con generaciÃ³n dinÃ¡mica de `dosbox.conf` y `compile.bat`.
- Script `scripts/clean.ps1` que limpia binarios de la raÃ­z y de `build/`.

### Changed

- Toolchain migrada de `MASM 6.11` a `MASM 5.00` (compatible con el paquete `shiburaj/masm-dos`).
- Scripts de automatizaciÃ³n migrados de `Start-Process` con `-c` a generaciÃ³n de archivos `.conf`/`.bat` (evita el bug de escape de backslashes en DOSBox 0.74).
- ConvenciÃ³n de nombres 8.3 aplicada a todos los archivos que MASM/LINK leen o escriben.

### Fixed

- `LOOP` con `CX=0` ejecutaba 65535 iteraciones por underflow â†’ resuelto con `JCXZ`.
- Nombres largos (`estacionamiento.asm`, `resultado.bin`) truncados a 8.3 por DOS â†’ renombrados a `estacion.asm`, `result.bin`.
- `.gitignore` inicial no cubrÃ­a artefactos generados (`*.log`, `*.bat`, `*.conf`, `*.bin`, `*.BIN`) â†’ ampliado.

### Removed

- Script `scripts/bootstrap/run-all.ps1` y sub-scripts (reemplazados por archivos individuales reescribibles).
- VersiÃ³n preliminar que usaba `DEBUG.EXE` con redirecciÃ³n de I/O (no soportada por el shell DOS).

[1.0.0]: https://github.com/axeljimenezdeveloper/estacionamiento-8086/releases/tag/v1.0.0