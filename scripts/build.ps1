<#
.SYNOPSIS
    Ensambla y enlaza un programa 8086 con MASM dentro de DOSBox.
.DESCRIPTION
    Genera build\compile.bat (comandos DOS, backslashes literales) y
    build\dosbox.conf (solo mount + cd + call, sin backslashes).
    Evita el bug de DOSBox 0.74 que come backslashes en [autoexec].
.EXAMPLE
    .\scripts\build.ps1
    .\scripts\build.ps1 -Source src/hola.asm
#>
param(
    [string]$Source = "src/hola.asm"
)

. "$PSScriptRoot\lib.ps1"
$projectRoot = (Resolve-Path "$PSScriptRoot\..").Path
Set-Location $projectRoot

$sourceRel  = ($Source -replace '/', '\')
$sourceName = [System.IO.Path]::GetFileNameWithoutExtension($Source)
$batPath    = Join-Path $projectRoot "build\compile.bat"
$confPath   = Join-Path $projectRoot "build\dosbox.conf"

# Localizar DOSBox
$dosboxCandidates = @(
    "C:\Program Files (x86)\DOSBox-0.74-3\DOSBox.exe",
    "C:\Program Files\DOSBox-0.74-3\DOSBox.exe",
    "C:\Program Files (x86)\DOSBox-0.74\DOSBox.exe",
    "C:\Program Files\DOSBox-0.74\DOSBox.exe"
)
$dosbox = $dosboxCandidates | Where-Object { Test-Path $_ } | Select-Object -First 1

if (-not $dosbox) { Write-Host "ERROR: DOSBox no encontrado." -ForegroundColor Red; exit 1 }
if (-not (Test-Path "C:\8086\MASM.EXE")) { Write-Host "ERROR: MASM no encontrado en C:\8086" -ForegroundColor Red; exit 1 }

# ---- compile.bat: DOS ejecuta esto literal (backslashes a salvo) ----
$batContent = @"
@echo off
cd ..\
d:\masm.exe $sourceRel, $sourceName.obj; > build\masm.log
d:\link.exe $sourceName.obj, $sourceName.exe; > build\link.log
"@
[System.IO.File]::WriteAllText($batPath, ($batContent -replace "`r?`n", "`r`n"), (New-Object System.Text.UTF8Encoding $false))

# ---- dosbox.conf: solo rutas con forward slash y sin comandos con backslash ----
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
compile.bat
exit
"@
[System.IO.File]::WriteAllText($confPath, ($confContent -replace "`r?`n", "`r`n"), (New-Object System.Text.UTF8Encoding $false))

Write-Host "Compilando: $sourceRel" -ForegroundColor Cyan
Write-Host "  DOSBox : $dosbox" -ForegroundColor DarkGray
Write-Host "  Bat    : $batPath" -ForegroundColor DarkGray
Write-Host "  Conf   : $confPath" -ForegroundColor DarkGray

# Ejecutar DOSBox
& $dosbox -conf $confPath -exit | Out-Null

# Verificar resultado
Write-Host "`nVerificando resultado..." -ForegroundColor Cyan
$exePath = Join-Path $projectRoot "$sourceName.exe"
$objPath = Join-Path $projectRoot "$sourceName.obj"

if (Test-Path $exePath) {
    $size = (Get-Item $exePath).Length
    Write-Host "OK: $sourceName.exe generado ($size bytes)" -ForegroundColor Green
} else {
    Write-Host "FAIL: $sourceName.exe NO se genero" -ForegroundColor Red
    if (Test-Path $objPath) {
        Write-Host "  El .obj existe: fallo en LINK. Ver build\link.log" -ForegroundColor Yellow
    } else {
        Write-Host "  Tampoco existe el .obj: fallo en MASM. Ver build\masm.log" -ForegroundColor Yellow
    }
    Write-Host "`n--- masm.log ---" -ForegroundColor Yellow
    Get-Content "build\masm.log" -ErrorAction SilentlyContinue
    Write-Host "`n--- link.log ---" -ForegroundColor Yellow
    Get-Content "build\link.log" -ErrorAction SilentlyContinue
    exit 1
}