#!/bin/bash

set -ouex pipefail

mkdir -p /etc/yum.repos.d

curl -fsSL https://github.com/terrapkg/subatomic-repos/raw/main/terra.repo | tee /etc/yum.repos.d/terra.repo
dnf5 -y install terra-release

dnf5 config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo

packages=(
  ghostty
  git
  vlc
  p7zip
  p7zip-plugins
  docker-buildx-plugin
  docker-ce
  docker-ce-cli
  docker-compose-plugin
  containerd.io
  podman-bootc
  podman-compose
  podman-machine
  podman-tui
  podmansh
)

dnf5 -y install "${packages[@]}"

if rpm -q docker-ce >/dev/null; then
  systemctl enable docker.socket
fi
