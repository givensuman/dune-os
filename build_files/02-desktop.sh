#!/bin/bash

echo "::group:: ===$(basename "$0")==="

set -euox pipefail

# Set up COSMIC
dnf5 -y swap @gnome-desktop @cosmic-desktop

packages=(
  ghostty
  rsms-inter-fonts
  hack-nerd-fonts

  gdisk
  gnome-disk-utility
)

dnf5 -y install "${packages[@]}" || {
  echo "Failed to install packages"
  exit 1
}

if systemctl cat -- gdm.service &>/dev/null; then
  systemctl disable gdm.service || true
fi
systemctl enable cosmic-greeter.service

echo "::endgroup::"
