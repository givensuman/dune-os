#!/usr/bin/bash

echo "::group:: ===$(basename "$0")==="

set -eoux pipefail

mkdir -p /etc/yum.repos.d
dnf5 -y install dnf-plugins-core

# Setup additional repos temporarily
dnf5 config-manager addrepo --from-repofile=https://github.com/terrapkg/subatomic-repos/raw/main/terra.repo
dnf5 config-manager addrepo --from-repofile=https://download.docker.com/linux/fedora/docker-ce.repo

dnf5 config-manager setopt terra.enabled=1 || true
dnf5 config-manager setopt docker-ce.enabled=1 || true

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
  systemctl enable iwd.service
else
  rm -rf /etc/NetworkManager/conf.d/iwd.conf
fi

if rpm -q docker-ce >/dev/null; then
  systemctl enable docker.socket
  systemctl enable containerd.service
  systemctl enable docker.service
fi

if rpm -q libvirt >/dev/null; then
  systemctl enable libvirtd.service
fi

# Disable additional repos
dnf5 config-manager setopt terra.enabled=0 || true
dnf5 config-manager setopt docker-ce.enabled=0 || true

echo "::endgroup::"
