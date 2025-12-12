#!/bin/bash

echo "::group:: ===$(basename "$0")==="

set -ouex pipefail

# Set up COSMIC
dnf5 -y swap @gnome-desktop @cosmic-desktop

systemctl disable gdm || true
systemctl --global enable cosmic-greeter

# Load system fonts
fc-cache -f /usr/share/fonts/hack
fc-cache -f /usr/share/fonts/inter

echo "::endgroup::"
