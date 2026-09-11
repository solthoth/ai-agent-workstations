#!/usr/bin/env bash

set -euo pipefail

echo "Installing base development packages..."

sudo apt-get update

sudo apt-get install -y \
  build-essential \
  ca-certificates \
  curl \
  wget \
  git \
  jq \
  unzip \
  zip \
  make \
  gnupg \
  lsb-release \
  openssh-client \
  rsync \
  vim

git config --global init.defaultBranch main
git config --global pull.rebase true
git config --global fetch.prune true

mkdir -p "${HOME}/src"
mkdir -p "${HOME}/bin"
mkdir -p "${HOME}/.local/bin"

echo "Base development packages installed."