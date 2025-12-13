#!/bin/bash

echo "::group:: ===$(basename "$0")==="

set -ouex pipefail

# Set up COSMIC
dnf5 -y swap @gnome-desktop @cosmic-desktop

packages=(
  gdisk
  gnome-disk-utility
  gnome-keyring
  gnome-keyring-pam
  plymouth-system-theme
)

dnf5 -y install "${packages[@]}" || {
  echo "Failed to install packages"
  exit 1
}

systemctl disable gdm || true
systemctl enable cosmic-greeter

# Load system fonts
fc-cache -f /usr/share/fonts/hack
fc-cache -f /usr/share/fonts/inter

echo "::endgroup::"
