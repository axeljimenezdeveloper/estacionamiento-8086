<#
.SYNOPSIS
    Ejecuta los 8 casos de prueba contra estacion.exe.
.DESCRIPTION
    Para cada tests/vectors/case-*.inc:
      1. Sustituye src/eventos.inc con el caso
      2. Compila, enlaza y ejecuta 'estacion.exe > result.bin'
      3. Lee los 2 bytes de result.bin
      4. Compara con EXPECT_OCUPADOS y EXPECT_DISPONIBLES
      5. Restaura src/eventos.inc
#>
param(
    [string]$Pattern = "tests/vectors/case-*.inc"
)

. "$PSScriptRoot\lib.ps1"
$projectRoot = (Resolve-Path "$PSScriptRoot\..").Path
Set-Location $projectRoot

$dosboxCandidates = @(
    "C:\Program Files (x86)\DOSBox-0.74-3\DOSBox.exe",
    "C:\Program Files\DOSBox-0.74-3\DOSBox.exe",
    "C:\Program Files (x86)\DOSBox-0.74\DOSBox.exe",
    "C:\Program Files\DOSBox-0.74\DOSBox.exe"
)
$dosbox = $dosboxCandidates | Where-Object { Test-Path $_ } | Select-Object -First 1
if (-not $dosbox) { Write-Host "ERROR: DOSBox no encontrado." -ForegroundColor Red; exit 1 }

$cases = @(Get-ChildItem $Pattern | Sort-Object Name)
if ($cases.Count -eq 0) { Write-Host "ERROR: No hay casos en $Pattern" -ForegroundColor Red; exit 1 }

$originalInc = Join-Path $projectRoot "src\eventos.inc"
$backupInc   = Join-Path $projectRoot "src\eventos.inc.orig"
Copy-Item $originalInc $backupInc -Force

$results = @()
$pass = 0
$fail = 0

foreach ($case in $cases) {
    $caseName = $case.BaseName
    Write-Host "`n=== Caso: $caseName ===" -ForegroundColor Cyan

    $content = Get-Content $case.FullName -Raw
    if ($content -notmatch 'EXPECT_OCUPADOS\s*=\s*(\d+)')    { Write-Host "  SKIP: sin EXPECT_OCUPADOS" -ForegroundColor Yellow; continue }
    $expOcupados = [int]$matches[1]
    if ($content -notmatch 'EXPECT_DISPONIBLES\s*=\s*(\d+)') { Write-Host "  SKIP: sin EXPECT_DISPONIBLES" -ForegroundColor Yellow; continue }
    $expDisponibles = [int]$matches[1]

    Write-Host "  Esperado: ocupados=$expOcupados, disponibles=$expDisponibles" -ForegroundColor DarkGray

    Copy-Item $case.FullName $originalInc -Force

    $batContent = @"
@echo off
cd ..\
d:\masm.exe src\estacion.asm, estacion.obj; > build\masm.log
d:\link.exe estacion.obj, estacion.exe; > build\link.log
estacion.exe > build\result.bin
"@
    [System.IO.File]::WriteAllText((Join-Path $projectRoot "build\run-test.bat"), ($batContent -replace "`r?`n", "`r`n"), (New-Object System.Text.UTF8Encoding $false))

    $rootDos = $projectRoot -replace '\\','/'
    $confContent = @"
[sdl]
autolock=false
fullscreen=false
windowresolution=original
output=surface

[dosbox]
machine=svga_s3
memsize=16

[autoexec]
mount c "$rootDos"
mount d "C:/8086"
c:
cd build
run-test.bat
exit
"@
    [System.IO.File]::WriteAllText((Join-Path $projectRoot "build\test-dosbox.conf"), ($confContent -replace "`r?`n", "`r`n"), (New-Object System.Text.UTF8Encoding $false))

    Remove-Item "build\masm.log","build\link.log","build\result.bin","build\RESULT.BIN" -ErrorAction SilentlyContinue
    Remove-Item "estacion.obj","estacion.exe" -ErrorAction SilentlyContinue

    & $dosbox -conf (Join-Path $projectRoot "build\test-dosbox.conf") -exit | Out-Null

    # DOS trunca a 8.3, asi que el archivo puede llamarse result.bin o RESULT.BIN
    $resultPath = $null
    foreach ($name in @("result.bin","RESULT.BIN")) {
        $candidate = Join-Path $projectRoot "build\$name"
        if (Test-Path $candidate) { $resultPath = $candidate; break }
    }

    if (-not $resultPath) {
        Write-Host "  FAIL: no se genero result.bin (ver build\masm.log)" -ForegroundColor Red
        $fail++
        $results += [PSCustomObject]@{ Case=$caseName; Status="FAIL"; Ocupados=-1; Disponibles=-1; Reason="no output" }
        continue
    }

    $bytes = [System.IO.File]::ReadAllBytes($resultPath)
    if ($bytes.Length -lt 2) {
        Write-Host "  FAIL: result.bin tiene $($bytes.Length) bytes (esperados 2)" -ForegroundColor Red
        $fail++
        $results += [PSCustomObject]@{ Case=$caseName; Status="FAIL"; Ocupados=-1; Disponibles=-1; Reason="short output" }
        continue
    }

    $gotOcupados    = [int]$bytes[0]
    $gotDisponibles = [int]$bytes[1]

    if ($gotOcupados -eq $expOcupados -and $gotDisponibles -eq $expDisponibles) {
        Write-Host "  PASS: ocupados=$gotOcupados, disponibles=$gotDisponibles" -ForegroundColor Green
        $pass++
        $results += [PSCustomObject]@{ Case=$caseName; Status="PASS"; Ocupados=$gotOcupados; Disponibles=$gotDisponibles; Reason="" }
    } else {
        Write-Host "  FAIL: esperado ($expOcupados, $expDisponibles), obtenido ($gotOcupados, $gotDisponibles)" -ForegroundColor Red
        $fail++
        $results += [PSCustomObject]@{ Case=$caseName; Status="FAIL"; Ocupados=$gotOcupados; Disponibles=$gotDisponibles; Reason="mismatch" }
    }
}

Move-Item $backupInc $originalInc -Force

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "Resumen: $pass PASS / $fail FAIL" -ForegroundColor $(if ($fail -eq 0) { "Green" } else { "Red" })
Write-Host "========================================" -ForegroundColor Cyan
$results | Format-Table Case, Status, Ocupados, Disponibles, Reason -AutoSize

if ($fail -gt 0) { exit 1 }