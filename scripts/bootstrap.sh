#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
BOOTSTRAP_VERSION="$(cat "${REPO_ROOT}/VERSION")"

echo "Agent development machine bootstrap ${BOOTSTRAP_VERSION}"

echo "Starting agent development machine bootstrap..."

"${SCRIPT_DIR}/00-base.sh"
"${SCRIPT_DIR}/10-docker.sh"
"${SCRIPT_DIR}/20-languages.sh"
"${SCRIPT_DIR}/30-kubernetes.sh"
"${SCRIPT_DIR}/40-cloud.sh"
"${SCRIPT_DIR}/50-ai.sh"

mkdir -p "${HOME}/src"

echo
echo "Bootstrap complete."
echo
echo "Development directory:"
echo "  ${HOME}/src"