# Guía de contribución

Flujo basado en **Conventional Commits**, ramas cortas de vida y Pull Requests.

## Estrategia de ramas

- **`main`** siempre estable y compilable.
- Ramas de trabajo: `feat/`, `fix/`, `docs/`, `test/`, `chore/`, `ci/`, `refactor/` + descripción corta.

## Convención de commits

Formato: `<tipo>(<scope>): <descripción en imperativo, minúsculas, sin punto final>`

**Tipos:** `chore`, `docs`, `feat`, `test`, `fix`, `refactor`, `ci`.

**Ejemplos válidos:**

```
chore: initialize repository structure
docs(design): add pseudocode for occupancy logic
feat(loop): implement sequential event traversal
fix(bounds): correct off-by-one in capacity check
```

**Reglas:**

- Un commit = un cambio lógico y compilable.
- Nunca commitear algo que no ensamble.
- Sin `WIP`, `update`, `cambios`, `fixes`.

## Estilo de código

- `.asm`: tabs (4 col. visuales), comentarios por sección (`; ===== DATA =====`, `; ===== CODE =====`), líneas ≤ 80 columnas cuando sea posible.
- `.md`: UTF-8 con acentos permitidos.
- Fin de línea: **LF** en `.asm`/`.md`/`.yml`; **CRLF** en `.bat`/`.ps1`.

## Flujo diario

```powershell
git checkout main
git pull origin main
git checkout -b feat/nombre-descriptivo

git add archivo
git commit -m "feat(scope): descripción imperativa"

git push -u origin feat/nombre-descriptivo
# PR en GitHub → Squash and merge

git checkout main
git pull
git branch -d feat/nombre-descriptivo
```

## Configuración del entorno

### 1. DOSBox 0.74-3

Descargar desde [dosbox.com](https://www.dosbox.com/) e instalar. Ruta típica en Windows 10/11: `C:\Program Files (x86)\DOSBox-0.74-3\DOSBox.exe`.

### 2. MASM 5.00 + LINK 3.60 + DEBUG

Descargar el paquete `8086` desde [shiburaj/masm-dos](https://github.com/shiburaj/masm-dos). Descomprimir en `C:\8086\`. Debe contener:

- `MASM.EXE`, `LINK.EXE`, `DEBUG.EXE`
- `EDIT.COM`, `EXE2BIN.EXE`, `TASM.EXE`, `TD.EXE`

### 3. PowerShell

Windows 10/11 ya lo incluye. Verificar con:

```powershell
$PSVersionTable.PSVersion
```

Debe ser ≥ 5.1.

### 4. Node.js (opcional)

Solo necesario para usar `npm run`. Descargar desde [nodejs.org](https://nodejs.org/). Alternativa: ejecutar los scripts directamente con `.\scripts\build.ps1`.

### 5. Verificar instalación

```powershell
cd C:\Development\UNAProjects\estacionamiento-8086
npm run build
npm run test
```

Esperado: `OK: estacion.exe generado` + `8 PASS / 0 FAIL`.

### 6. Convenciones de rutas

- Los nombres de archivos que MASM/LINK lean o escriban deben ser **8.3** (≤8 caracteres + extensión). Ej: `estacion.asm`, `result.bin`, `masm.log`.
- Los nombres largos que solo PowerShell manipule no tienen esa restricción.