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

_(Se completará en la Fase 1.)_