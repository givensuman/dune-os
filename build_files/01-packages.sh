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

  # Container/Atomic utilities
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
  echo "[DEBUG] iwd package missing"
  rm -rf /etc/NetworkManager/conf.d/iwd.conf
fi

if rpm -q docker-ce >/dev/null; then
  systemctl --global enable containerd.service || true
  systemctl --global enable docker.service || true
else
  echo "[DEBUG] docker-ce package missing"
fi

if rpm -q libvirt >/dev/null; then
  systemctl --global enable libvirtd.service
else
  echo "[DEBUG] libvirtd package missing"
fi

echo "::endgroup::"
