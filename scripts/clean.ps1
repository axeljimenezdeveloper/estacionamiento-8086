. "$PSScriptRoot\lib.ps1"
Set-Location (Resolve-Path "$PSScriptRoot\..")

Write-Host "Limpiando binarios generados..." -ForegroundColor Cyan

$patterns = @("*.obj","*.exe","*.com","*.lst","*.map","*.crf","*.sbr","*.ref")
$locations = @(".", "build")

foreach ($loc in $locations) {
    foreach ($p in $patterns) {
        Get-ChildItem -Path $loc -Filter $p -File -ErrorAction SilentlyContinue |
            Remove-Item -Force
    }
}

# Logs del build
Get-ChildItem -Path "build" -Filter "*.log" -File -ErrorAction SilentlyContinue |
    Remove-Item -Force

# Binarios y dumps de test
Get-ChildItem -Path "build" -Include "*.bin","*.BIN" -File -ErrorAction SilentlyContinue |
    Remove-Item -Force
Get-ChildItem -Path "build" -Filter "*.txt" -File -ErrorAction SilentlyContinue |
    Remove-Item -Force

Write-Host "Listo." -ForegroundColor Green

