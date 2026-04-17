#!/usr/bin/env sh
# Run flutter with a PATH that works from Git hooks (Cursor/VS Code often
# inherit a minimal PATH and skip ~/.zshrc).

set -eu

if command -v flutter >/dev/null 2>&1; then
  exec flutter "$@"
fi

# Homebrew cask (Apple Silicon default)
if [ -x "/opt/homebrew/bin/flutter" ]; then
  PATH="/opt/homebrew/bin:$PATH"
  export PATH
  exec flutter "$@"
fi

# Homebrew cask (Intel Mac default)
if [ -x "/usr/local/bin/flutter" ]; then
  PATH="/usr/local/bin:$PATH"
  export PATH
  exec flutter "$@"
fi

if [ -n "${FLUTTER_ROOT:-}" ] && [ -x "${FLUTTER_ROOT}/bin/flutter" ]; then
  PATH="${FLUTTER_ROOT}/bin:$PATH"
  export PATH
  exec flutter "$@"
fi

for root in \
  "${HOME}/Workspace/tools/flutter" \
  "${HOME}/flutter" \
  "${HOME}/development/flutter" \
  "${HOME}/sdk/flutter"; do
  if [ -x "${root}/bin/flutter" ]; then
    PATH="${root}/bin:$PATH"
    export PATH
    exec flutter "$@"
  fi
done

# FVM default symlink (common layout)
if [ -L "${HOME}/fvm/default" ]; then
  fvm_root="$(cd -P "${HOME}/fvm/default" && pwd)"
  if [ -x "${fvm_root}/bin/flutter" ]; then
    PATH="${fvm_root}/bin:$PATH"
    export PATH
    exec flutter "$@"
  fi
fi

# Project-local FVM SDK (run from repo root)
repo_root="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
if [ -x "${repo_root}/.fvm/flutter_sdk/bin/flutter" ]; then
  PATH="${repo_root}/.fvm/flutter_sdk/bin:$PATH"
  export PATH
  exec flutter "$@"
fi

echo "flutter: command not found in this environment (common when committing from the IDE)."
echo "Fix one of:"
echo "  - Set FLUTTER_ROOT to your Flutter SDK directory (contains bin/flutter)."
echo "  - Add Flutter bin to PATH in ~/.zprofile so login tools see it."
echo "  - Start Cursor from a terminal where flutter works: cursor ."
exit 127
