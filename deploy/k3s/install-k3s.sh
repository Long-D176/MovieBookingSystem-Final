#!/usr/bin/env bash
set -euo pipefail

K3S_VERSION="${K3S_VERSION:-v1.33.4+k3s1}"
INSTALL_USER="${INSTALL_USER:-ubuntu}"

if ! command -v k3s >/dev/null 2>&1; then
  curl -sfL https://get.k3s.io | \
    INSTALL_K3S_VERSION="$K3S_VERSION" \
    INSTALL_K3S_EXEC="server --disable traefik --disable servicelb --write-kubeconfig-mode 644" \
    sh -
fi

sudo apt-get update -y
sudo apt-get install -y gettext-base

sudo mkdir -p "/home/${INSTALL_USER}/.kube"
sudo cp /etc/rancher/k3s/k3s.yaml "/home/${INSTALL_USER}/.kube/config"
sudo chown -R "${INSTALL_USER}:${INSTALL_USER}" "/home/${INSTALL_USER}/.kube"

echo "k3s is installed and kubeconfig is ready for ${INSTALL_USER}."
