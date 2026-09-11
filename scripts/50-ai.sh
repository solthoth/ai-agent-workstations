#!/usr/bin/env bash

set -euo pipefail

echo "Installing AI development agents..."

mkdir -p "${HOME}/.local/bin"

export PATH="${HOME}/.local/bin:${PATH}"

#
# Claude Code
#

if ! command -v claude >/dev/null 2>&1; then
  echo "Installing Claude Code..."

  curl -fsSL https://claude.ai/install.sh | bash
else
  echo "Claude Code already installed."
fi

#
# OpenAI Codex
#

if ! command -v codex >/dev/null 2>&1; then
  echo "Installing Codex..."

  curl -fsSL https://chatgpt.com/codex/install.sh | sh
else
  echo "Codex already installed."
fi

echo
echo "AI tooling installed:"

claude --version
codex --version