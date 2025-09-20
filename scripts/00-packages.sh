#!/bin/bash

set -ouex pipefail

mkdir -p /etc/yum.repos.d
dnf5 -y install dnf-plugins-core

# Setup additional repos
dnf5 config-manager addrepo --from-repofile=https://github.com/terrapkg/subatomic-repos/raw/main/terra.repo
dnf5 config-manager addrepo --from-repofile=https://download.docker.com/linux/fedora/docker-ce.repo

packages=(
  # Opinionated additions
  ghostty

  # System packages
  git
  vlc
  p7zip
  p7zip-plugins
  wayland-protocols-devel

  # Useful for atomic systems
  docker-buildx-plugin
  docker-ce
  docker-ce-cli
  docker-compose-plugin
  containerd.io
  podman-compose
)

dnf5 -y install "${packages[@]}"

if rpm -q docker-ce >/dev/null; then
  systemctl enable docker.socket
  systemctl enable containerd.service
  systemctl enable docker.service
fi

# Disable additional repos
sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/terra.repo
sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/docker-ce.repo
