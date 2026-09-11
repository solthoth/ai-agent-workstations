#!/usr/bin/env bash

set -euo pipefail

echo "Installing cloud and infrastructure tooling..."

sudo mkdir -p -m 0755 /etc/apt/keyrings

#
# GitHub CLI
#

if ! command -v gh >/dev/null 2>&1; then
  echo "Installing GitHub CLI..."

  curl -fsSL \
    https://cli.github.com/packages/githubcli-archive-keyring.gpg \
    | sudo tee \
      /etc/apt/keyrings/githubcli-archive-keyring.gpg \
      > /dev/null

  sudo chmod go+r \
    /etc/apt/keyrings/githubcli-archive-keyring.gpg

  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
    | sudo tee \
      /etc/apt/sources.list.d/github-cli.list \
      > /dev/null

  sudo apt-get update
  sudo apt-get install -y gh
else
  echo "GitHub CLI already installed."
fi

#
# Azure CLI
#

if ! command -v az >/dev/null 2>&1; then
  echo "Installing Azure CLI..."

  sudo apt-get update

  sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

  curl -sLS \
    https://packages.microsoft.com/keys/microsoft.asc \
    | gpg --dearmor \
    | sudo tee /etc/apt/keyrings/microsoft.gpg \
      > /dev/null

  sudo chmod go+r /etc/apt/keyrings/microsoft.gpg

  AZ_DIST="$(lsb_release -cs)"

  cat <<EOF | sudo tee /etc/apt/sources.list.d/azure-cli.sources > /dev/null
Types: deb
URIs: https://packages.microsoft.com/repos/azure-cli/
Suites: ${AZ_DIST}
Components: main
Architectures: $(dpkg --print-architecture)
Signed-by: /etc/apt/keyrings/microsoft.gpg
EOF

  sudo apt-get update
  sudo apt-get install -y azure-cli
else
  echo "Azure CLI already installed."
fi

#
# Terraform
#

# if ! command -v terraform >/dev/null 2>&1; then
#   echo "Installing Terraform..."

#   curl -fsSL \
#     https://apt.releases.hashicorp.com/gpg \
#     | sudo gpg --dearmor \
#       -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

#   UBUNTU_CODENAME="$(
#     grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release \
#       || lsb_release -cs
#   )"

#   echo \
#     "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com ${UBUNTU_CODENAME} main" \
#     | sudo tee \
#       /etc/apt/sources.list.d/hashicorp.list \
#       > /dev/null

#   sudo apt-get update
#   sudo apt-get install -y terraform
# else
#   echo "Terraform already installed."
# fi

#
# OpenTofu
#

if ! command -v tofu >/dev/null 2>&1; then
  echo "Installing OpenTofu..."

  sudo install -m 0755 -d /etc/apt/keyrings

  curl -fsSL \
    https://get.opentofu.org/opentofu.gpg \
    | sudo tee \
      /etc/apt/keyrings/opentofu.gpg \
      > /dev/null

  curl -fsSL \
    https://packages.opentofu.org/opentofu/tofu/gpgkey \
    | sudo gpg \
      --no-tty \
      --batch \
      --dearmor \
      -o /etc/apt/keyrings/opentofu-repo.gpg

  sudo chmod a+r \
    /etc/apt/keyrings/opentofu.gpg \
    /etc/apt/keyrings/opentofu-repo.gpg

  cat <<EOF | sudo tee /etc/apt/sources.list.d/opentofu.list > /dev/null
deb [signed-by=/etc/apt/keyrings/opentofu.gpg,/etc/apt/keyrings/opentofu-repo.gpg] https://packages.opentofu.org/opentofu/tofu/any/ any main
deb-src [signed-by=/etc/apt/keyrings/opentofu.gpg,/etc/apt/keyrings/opentofu-repo.gpg] https://packages.opentofu.org/opentofu/tofu/any/ any main
EOF

  sudo chmod a+r \
    /etc/apt/sources.list.d/opentofu.list

  sudo apt-get update
  sudo apt-get install -y tofu
else
  echo "OpenTofu already installed."
fi

echo
echo "Cloud tooling installed:"

gh --version | head -n 1
az version --output table
# terraform version
tofu version