#!/usr/bin/env bash

set -euo pipefail

echo "Installing language and runtime tooling..."

MISE_BIN="${HOME}/.local/bin/mise"

mkdir -p "${HOME}/.local/bin"

if [ ! -x "${MISE_BIN}" ]; then
  echo "Installing mise..."
  curl -fsSL https://mise.run | sh
else
  echo "mise already installed."
fi

# Make mise available to this script immediately.
export PATH="${HOME}/.local/bin:${PATH}"

# Ensure mise activates in future bash sessions.
if ! grep -q 'mise activate bash' "${HOME}/.bashrc"; then
  echo 'eval "$(~/.local/bin/mise activate bash)"' >> "${HOME}/.bashrc"
fi

echo "Installing default runtimes..."

mise use --global go@latest
mise use --global node@lts
mise use --global python@latest
mise use --global age@latest
mise use --global sops@latest

echo
echo "Installed runtimes:"
mise current

echo
go version
node --version
npm --version
python --version