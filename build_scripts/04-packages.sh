#!/usr/bin/bash

echo "::group:: ===$(basename "$0")==="

set -eoux pipefail

mkdir -p /etc/yum.repos.d
dnf5 -y install dnf-plugins-core

# Setup additional repos temporarily
dnf5 config-manager addrepo --from-repofile=https://github.com/terrapkg/subatomic-repos/raw/main/terra.repo
dnf5 config-manager addrepo --from-repofile=https://download.docker.com/linux/fedora/docker-ce.repo

# Group packages by source for better caching
packages=(
  # Core packages
  git
  p7zip
  p7zip-plugins
  wayland-protocols-devel

  # Opinionated additions
  ghostty
  vlc

  # Container/Atomic packages
  docker-buildx-plugin
  docker-ce
  docker-ce-cli
  docker-compose-plugin
  containerd.io
  podman-compose
)

dnf5 -y install "${packages[@]}" || {
  echo "Failed to install packages"
  exit 1
}

if rpm -q docker-ce >/dev/null; then
  systemctl enable docker.socket
  systemctl enable containerd.service
  systemctl enable docker.service
fi

# Disable additional repos
[ -f /etc/yum.repos.d/terra.repo ] && sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/terra.repo
[ -f /etc/yum.repos.d/docker-ce.repo ] && sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/docker-ce.repo

echo "::endgroup::"

