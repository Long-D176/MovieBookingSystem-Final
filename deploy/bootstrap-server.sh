#!/usr/bin/env bash
set -euo pipefail

sudo apt-get update -y
sudo apt-get install -y docker.io docker-compose-v2 git curl
sudo systemctl enable --now docker
sudo usermod -aG docker "$USER"

echo "Docker version:"
docker --version || true

echo "Docker Compose version:"
docker compose version || true

echo "Git version:"
git --version

echo
echo "Server bootstrap complete."
echo "If the current user was not already in the docker group, log out and back in before running docker without sudo."
