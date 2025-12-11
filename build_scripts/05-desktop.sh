#!/bin/bash

echo "::group:: ===$(basename "$0")==="

set -ouex pipefail

# Set up COSMIC
dnf5 -y swap @gnome-desktop @cosmic-desktop

systemctl disable gdm || true
systemctl --global enable cosmic-greeter

fc-cache -f /usr/share/fonts/Hack
fc-cache -f /usr/share/fonts/Inter

echo "::endgroup::"
