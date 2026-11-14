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

Write-Host "Listo." -ForegroundColor Green