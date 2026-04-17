# One-shot project setup for Windows (PowerShell).
# Prerequisite: Flutter SDK installed and flutter on your PATH.

$ErrorActionPreference = "Stop"
Set-Location (Join-Path $PSScriptRoot "..")
Write-Host "==> BookNest setup"
Write-Host "    Project root: $(Get-Location)"
Write-Host ""

if (-not (Get-Command flutter -ErrorAction SilentlyContinue)) {
  Write-Host "Error: flutter not found in PATH."
  Write-Host "Install Flutter first: https://docs.flutter.dev/get-started/install/windows"
  exit 1
}

Write-Host "==> [1/4] Fetching packages (flutter pub get)..."
flutter pub get

Write-Host ""
Write-Host "==> [2/4] Static analysis (flutter analyze)..."
flutter analyze

Write-Host ""
Write-Host "==> [3/4] Running tests (flutter test)..."
flutter test

Write-Host ""
Write-Host "==> [4/4] Git hooks (Lefthook, optional)..."
if (Get-Command lefthook -ErrorAction SilentlyContinue) {
  lefthook install
  Write-Host "    Lefthook hooks installed."
} else {
  Write-Host "    Skipped: lefthook not installed."
  Write-Host "    Install from: https://github.com/evilmartians/lefthook/blob/master/docs/install.md"
}

Write-Host ""
Write-Host "==> Setup finished successfully."
Write-Host "    Run the app:  flutter run -d chrome"
Write-Host "    List devices: flutter devices"
