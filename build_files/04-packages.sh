#!/usr/bin/bash

echo "::group:: ===$(basename "$0")==="

set -eoux pipefail

mkdir -p /etc/yum.repos.d
dnf5 -y install dnf-plugins-core

# Setup additional repos temporarily
dnf5 config-manager addrepo --from-repofile=https://github.com/terrapkg/subatomic-repos/raw/main/terra.repo
dnf5 config-manager addrepo --from-repofile=https://download.docker.com/linux/fedora/docker-ce.repo

packages=(
  # System packages
  git
  iwd
  p7zip
  p7zip-plugins
  mpv
  vlc
  vlc-plugin-bittorrent
  vlc-plugin-ffmpeg
  vlc-plugin-pause-click
  wayland-protocols-devel
  util-linux

  # Opinionated additions
  fish
  ghostty
  mise

  # Container/Atomic packages
  docker-buildx-plugin
  docker-ce
  docker-ce-cli
  docker-compose-plugin
  containerd.io
  podlet
  podman-compose
  podman-remote
  qemu-kvm
  libvirt
  virt-manager
  virt-viewer
  virt-install
)

dnf5 -y install "${packages[@]}" || {
  echo "Failed to install packages"
  exit 1
}

if rpm -q iwd >/dev/null; then
  systemctl --global enable iwd.service
fi

if rpm -q docker-ce >/dev/null; then
  systemctl --global enable docker.socket
  systemctl --global enable containerd.service
  systemctl --global enable docker.service
fi

if rpm -q libvirt >/dev/null; then
  systemctl --global enable libvirtd.service
fi

# Disable additional repos
[ -f /etc/yum.repos.d/terra.repo ] && sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/terra.repo
[ -f /etc/yum.repos.d/docker-ce.repo ] && sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/docker-ce.repo

echo "::endgroup::"
