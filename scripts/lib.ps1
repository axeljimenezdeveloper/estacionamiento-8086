function Write-Utf8NoBom {
    param(
        [Parameter(Mandatory)][string]$Path,
        [Parameter(Mandatory)][string]$Content,
        [switch]$Append
    )
    $abs = Join-Path (Get-Location).Path $Path
    $dir = Split-Path $abs -Parent
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
    $enc = New-Object System.Text.UTF8Encoding $false
    try {
        if ($Append -and (Test-Path $abs)) {
            [System.IO.File]::AppendAllText($abs, $Content, $enc)
            Write-Host "  anadido: $Path" -ForegroundColor DarkGray
        } else {
            [System.IO.File]::WriteAllText($abs, $Content, $enc)
            Write-Host "  escrito: $Path" -ForegroundColor DarkGray
        }
    } catch {
        Write-Host "  ERROR en $Path : $($_.Exception.Message)" -ForegroundColor Red
    }
}