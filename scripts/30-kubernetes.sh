#!/usr/bin/env bash

set -euo pipefail

echo "Installing Kubernetes and GitOps tooling..."

export PATH="${HOME}/.local/bin:${PATH}"

#
# kubectl
#

if ! command -v kubectl >/dev/null 2>&1; then
  echo "Installing kubectl..."

  sudo mkdir -p -m 755 /etc/apt/keyrings

  curl -fsSL \
    https://pkgs.k8s.io/core:/stable:/v1.37/deb/Release.key \
    | sudo gpg --dearmor \
      -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

  sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg

  echo \
    'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.37/deb/ /' \
    | sudo tee /etc/apt/sources.list.d/kubernetes.list > /dev/null

  sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list

  sudo apt-get update
  sudo apt-get install -y kubectl
else
  echo "kubectl already installed."
fi

#
# Helm
#

if ! command -v helm >/dev/null 2>&1; then
  echo "Installing Helm..."
  mise use --global helm@latest
else
  echo "Helm already installed."
fi

#
# Flux
#

if ! command -v flux >/dev/null 2>&1; then
  echo "Installing Flux..."
  mise use --global flux2@latest
else
  echo "Flux already installed."
fi

#
# Kustomize
#

if ! command -v kustomize >/dev/null 2>&1; then
  echo "Installing Kustomize..."
  mise use --global kustomize@latest
else
  echo "Kustomize already installed."
fi

#
# Argo CD CLI
#

if ! command -v argocd >/dev/null 2>&1; then
  echo "Installing Argo CD CLI..."

  ARCH="$(dpkg --print-architecture)"

  case "${ARCH}" in
    arm64)
      ARGO_ARCH="arm64"
      ;;
    amd64)
      ARGO_ARCH="amd64"
      ;;
    *)
      echo "Unsupported architecture for Argo CD: ${ARCH}"
      exit 1
      ;;
  esac

  TMP_FILE="$(mktemp)"

  curl -fsSL \
    "https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-${ARGO_ARCH}" \
    -o "${TMP_FILE}"

  sudo install -m 0555 "${TMP_FILE}" /usr/local/bin/argocd

  rm -f "${TMP_FILE}"
else
  echo "Argo CD already installed."
fi

echo
echo "Kubernetes tooling installed:"
kubectl version --client
helm version --short
flux version --client
kustomize version
argocd version --client