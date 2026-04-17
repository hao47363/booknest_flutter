# BookNest (Flutter Demo App)

A local-first Flutter bookstore demo app that mimics a real mobile/web app flow without backend services.

## Features

- Local persistence with `Hive` (books, profile, favorites, cart, orders, session state)
- Mock auth flow (login/register/logout)
- Onboarding flow (first launch)
- Product catalog with search, filter, and sort
- Product CRUD simulation (manage products)
- Favorites and cart
- Checkout simulation with order creation
- Mock API delays and optional API error simulation mode
- Local image assets saved in this repo

---

## Tech Stack

- Flutter `3.29.0`
- Dart `3.7.0`
- `go_router`
- `hive_flutter`

> Recommended: Flutter/Dart versions close to the above for consistent behavior.

---

## Quick Start (Fresh Clone)

```bash
git clone <your-repo-url>
cd <repo-folder>
flutter pub get
flutter run -d chrome
```

If `flutter` is not recognized, follow the OS-specific setup below.

---

## Environment Setup

## macOS Setup

### 1) Install Flutter SDK

Use one of these options:

- Install via [Flutter docs](https://docs.flutter.dev/get-started/install/macos)
- Or download and extract manually, then add `flutter/bin` to `PATH`

Example `~/.zshrc` entry:

```bash
export PATH="/path/to/flutter/bin:$PATH"
```

Reload shell:

```bash
source ~/.zshrc
```

### 2) Verify installation

```bash
flutter --version
dart --version
flutter doctor -v
```

### 3) Optional platform tools

- For iOS/macOS apps: install Xcode and CocoaPods
- For Android apps: install Android Studio + Android SDK
- On Apple Silicon, Flutter may require Rosetta for some tooling:

```bash
sudo softwareupdate --install-rosetta --agree-to-license
```

---

## Windows Setup

### 1) Install Flutter SDK

Follow [Flutter Windows install](https://docs.flutter.dev/get-started/install/windows):

- Download Flutter SDK zip
- Extract to a stable path (example: `C:\src\flutter`)
- Add `C:\src\flutter\bin` to your system `Path`

### 2) Verify installation

Open a new PowerShell and run:

```powershell
flutter --version
dart --version
flutter doctor -v
```

### 3) Optional platform tools

- For Android: install Android Studio + SDK
- For Windows desktop app support: install Visual Studio (Desktop development with C++)

---

## Run the App

From project root:

```bash
flutter pub get
flutter run -d chrome
```

Other useful targets:

```bash
flutter devices
flutter run -d macos      # macOS only
flutter run -d windows    # Windows only
flutter run -d android    # if Android SDK/device is available
```

---

## Development Commands

```bash
flutter analyze
flutter test
```

---

## Project Structure (High Level)

```text
lib/
  core/
    data/      # seed/mock data
    models/    # app models
    state/     # app state + persistence logic
  features/
    auth/
    catalog/
    cart/
    favorites/
    orders/
    onboarding/
    profile/
  routes/
  shared/
assets/images/  # local image assets used by mock data
```

---

## Troubleshooting

- `flutter: command not found`
  - Ensure Flutter is installed and `flutter/bin` is in `PATH`
  - Restart terminal/IDE after updating `PATH`

- `Doctor found issues`
  - Run `flutter doctor -v` and complete missing toolchains
  - Web (`-d chrome`) can run even if mobile toolchains are incomplete

- App changes not reflected
  - Press `R` (hot restart) in running terminal
  - Or stop and rerun `flutter run -d chrome`

---

## Notes

- This app intentionally uses local mock data and simulated latency.
- No backend services are required.

---

## Git Hooks and CI Workflow

### Local enforcement with Lefthook

Full rules and examples: [docs/naming-conventions.md](docs/naming-conventions.md).

This repository uses `lefthook` for local commit checks:

- `pre-commit`
  - branch name validation (`scripts/validate_branch_name.sh`)
  - `flutter analyze`
  - `flutter test`
- `commit-msg`
  - commit message validation (`scripts/validate_commit_msg.sh`)

Install and enable hooks:

```bash
brew install lefthook
lefthook install
```

If commits from Cursor show `flutter: command not found` in the pre-commit hook, the IDE is using a minimal `PATH` (it does not load `~/.zshrc`). Fix it by doing one of:

- Set `FLUTTER_ROOT` to your SDK folder (the one that contains `bin/flutter`), e.g. in `~/.zprofile`: `export FLUTTER_ROOT="$HOME/flutter"`
- Or add Flutter’s `bin` to `PATH` in `~/.zprofile` (login shells), not only in `~/.zshrc`
- Or start Cursor from a terminal where `flutter` already works: `cursor .`

Hooks run `flutter` via `scripts/run_flutter.sh`, which checks `FLUTTER_ROOT`, common install paths, FVM, and project `.fvm/flutter_sdk`.

Commit message format:

```text
<type>(<scope>): <message>
```

Example:

```text
feat(cart): implement add to cart option
```

Allowed commit `type` values:

- `feat`
- `fix`
- `chore`
- `docs`
- `refactor`
- `test`
- `perf`
- `ci`
- `build`
- `style`
- `revert`

Branch name format:

```text
<type>/<branch-name>
```

Examples:

- `feature/cart-add-item`
- `fix/login-null-check`
- `chore/update-readme`

These branch names are exempt from the `<type>/<name>` rule: `main`, `develop`, `staging`.

Allowed branch `type` values:

- `feature`
- `feat`
- `fix`
- `chore`
- `docs`
- `refactor`
- `test`
- `perf`
- `ci`
- `build`
- `style`
- `revert`

### GitHub Actions

Workflows:

- `.github/workflows/ci.yml`
  - validates branch naming and commit message format
  - runs `flutter analyze` and `flutter test`
  - builds Android debug APK for pull requests
  - uploads APK artifact and updates PR comment with artifact location
- `.github/workflows/pr-automation.yml`
  - auto-creates pull requests for pushed branches that match naming rules

### Required GitHub repository settings

1. **Actions permissions**
   - Repository Settings -> Actions -> General
   - Allow GitHub Actions
   - Set workflow permissions to **Read and write permissions** (needed for PR create/comment updates)
2. **Branch protection**
   - Repository Settings -> Branches -> Add rule for `main`
   - Enable:
     - Require a pull request before merging
     - Require status checks to pass before merging
   - Select CI checks from `.github/workflows/ci.yml`
