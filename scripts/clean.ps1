. "$PSScriptRoot\lib.ps1"
Set-Location (Resolve-Path "$PSScriptRoot\..")
Write-Host "Limpiando binarios generados..." -ForegroundColor Cyan
$patterns = @("*.obj","*.exe","*.com","*.lst","*.map","*.crf","*.sbr","*.ref")
foreach ($p in $patterns) {
    Get-ChildItem -Path "build" -Filter $p -ErrorAction SilentlyContinue | Remove-Item -Force
}
Write-Host "Listo." -ForegroundColor Green