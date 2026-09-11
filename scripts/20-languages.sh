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

export PATH="${HOME}/.local/bin:${PATH}"

#
# Configure future interactive shells.
#

if ! grep -q 'mise activate bash' "${HOME}/.bashrc"; then
  echo 'eval "$(~/.local/bin/mise activate bash)"' >> "${HOME}/.bashrc"
fi

#
# Activate mise NOW for this provisioning shell.
#

eval "$("${MISE_BIN}" activate bash)"

echo "mise version:"
mise --version

mise use --global go@latest
mise use --global node@lts
mise use --global python@latest
mise use --global age@latest
mise use --global sops@latest

echo
echo "Currently selected runtimes:"
mise ls --current

echo
echo "Runtime versions:"

mise exec -- go version
mise exec -- node --version
mise exec -- npm --version
mise exec -- python --version

echo
echo "Language/runtime installation complete."