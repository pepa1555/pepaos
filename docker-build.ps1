# Pepa OS - Docker build pro Windows
# Vyžaduje: Docker Desktop pro Windows

$ImageName = "pepaos-builder"
$WorkDir = "$PWD\out"

if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    Write-Host "Error: Docker není nainstalovaný. Stáhni Docker Desktop z https://www.docker.com/products/docker-desktop/" -ForegroundColor Red
    exit 1
}

Write-Host "[*] Building Pepa OS ISO v Dockeru..." -ForegroundColor Cyan
New-Item -ItemType Directory -Force -Path $WorkDir | Out-Null

docker build -t $ImageName -f Dockerfile .
if ($LASTEXITCODE -ne 0) {
    Write-Host "Error: Docker build selhal" -ForegroundColor Red
    exit 1
}

Write-Host "[*] Spouštím build ISO (to může trvat 10-30 minut)..." -ForegroundColor Cyan
docker run --privileged --rm `
    -v "${WorkDir}:/output" `
    $ImageName

if ($LASTEXITCODE -eq 0) {
    Write-Host "[✓] Hotovo! ISO je v: $WorkDir" -ForegroundColor Green
    Get-ChildItem $WorkDir -Filter *.iso | ForEach-Object { Write-Host "    $($_.Name) ($([math]::Round($_.Length/1MB, 1)) MB)" -ForegroundColor Yellow }
}
