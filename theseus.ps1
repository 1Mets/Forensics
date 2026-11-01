cls
$targetHash = "0B4ED33EE20440042C772FFB37F1A815C2CD7D0EC3E8287DD07209B170F48F42"
$tempPath = "$env:LOCALAPPDATA\Temp"

Write-Host "Scanning $tempPath for 'theseus.jar'..." -ForegroundColor Cyan

$files = Get-ChildItem -Path $tempPath -Filter "theseus.jar" -Recurse -ErrorAction SilentlyContinue

if (-not $files) {
    Write-Host "No 'theseus.jar' files found." -ForegroundColor Yellow
    return
}

foreach ($file in $files) {
    $currentHash = (Get-FileHash $file.FullName -Algorithm SHA256).Hash
    if ($currentHash -eq $targetHash) {
        Write-Host "[MATCH] Valid file found at: $($file.FullName)" -ForegroundColor Green
    } else {
        Write-Host "[FLAGGED] Hash mismatch for: $($file.FullName)" -ForegroundColor Red
        Write-Host "  Expected: $targetHash" -ForegroundColor Yellow
        Write-Host "  Found:    $currentHash" -ForegroundColor Yellow
    }
}
