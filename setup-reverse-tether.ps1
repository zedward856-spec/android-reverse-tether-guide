<#
.SYNOPSIS
    Automated Android USB Reverse Tethering Script for Windows
.DESCRIPTION
    Downloads Gnirehtet & ADB (if missing) and initiates reverse tethering to connected device.
#>

$ErrorActionPreference = "Stop"
$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# Download Gnirehtet if not present
if (-not (Test-Path "$toolsDir\gnirehtet.exe")) {
    Write-Host "[1/3] Downloading Gnirehtet..." -ForegroundColor Cyan
    $zipPath = "$toolsDir\gnirehtet.zip"
    Invoke-WebRequest -Uri "https://github.com/Genymobile/gnirehtet/releases/download/v2.5.1/gnirehtet-rust-win64-v2.5.1.zip" -OutFile $zipPath
    Expand-Archive -Path $zipPath -DestinationPath "$toolsDir\gnirehtet_temp" -Force
    Copy-Item "$toolsDir\gnirehtet_temp\gnirehtet-rust-win64\*" "$toolsDir\" -Force
    Remove-Item "$toolsDir\gnirehtet_temp", $zipPath -Recurse -Force
}

# Download ADB if not present
if (-not (Test-Path "$toolsDir\adb.exe")) {
    Write-Host "[2/3] Downloading ADB platform-tools..." -ForegroundColor Cyan
    $adbZip = "$toolsDir\adb.zip"
    Invoke-WebRequest -Uri "https://dl.google.com/android/repository/platform-tools-latest-windows.zip" -OutFile $adbZip
    Expand-Archive -Path $adbZip -DestinationPath "$toolsDir\adb_temp" -Force
    Copy-Item "$toolsDir\adb_temp\platform-tools\*" "$toolsDir\" -Force
    Remove-Item "$toolsDir\adb_temp", $adbZip -Recurse -Force
}

Write-Host "[3/3] Checking connected Android devices..." -ForegroundColor Green
$env:PATH = "$toolsDir;" + $env:PATH
& "$toolsDir\adb.exe" devices

Write-Host "`nStarting Gnirehtet Reverse Tethering (Press Ctrl+C to stop)..." -ForegroundColor Yellow
& "$toolsDir\gnirehtet.exe" run
