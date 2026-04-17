#!/usr/bin/env bash
# One-shot project setup: dependencies, checks, and optional Git hooks.
# Prerequisite: Flutter SDK installed and `flutter` on your PATH (see README).

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

echo "==> BookNest setup"
echo "    Project root: $ROOT"
echo

if ! command -v flutter >/dev/null 2>&1; then
  echo "Error: flutter not found in PATH."
  echo "Install Flutter first, then add its bin directory to PATH:"
  echo "  https://docs.flutter.dev/get-started/install"
  exit 1
fi

echo "==> [1/4] Fetching packages (flutter pub get)..."
flutter pub get

echo
echo "==> [2/4] Static analysis (flutter analyze)..."
flutter analyze

echo
echo "==> [3/4] Running tests (flutter test)..."
flutter test

echo
echo "==> [4/4] Git hooks (Lefthook, optional)..."
if command -v lefthook >/dev/null 2>&1; then
  lefthook install
  echo "    Lefthook hooks installed."
else
  echo "    Skipped: lefthook not installed."
  echo "    To install later: https://github.com/evilmartians/lefthook/blob/master/docs/install.md"
  echo "    Example (macOS): brew install lefthook && lefthook install"
fi

echo
echo "==> Setup finished successfully."
echo "    Run the app:"
echo "      flutter run -d chrome"
echo "    List devices:"
echo "      flutter devices"
