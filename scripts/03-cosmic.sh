#!/bin/bash

set -ouex pipefail

dnf5 -y swap @gnome-desktop @cosmic-desktop

if systemctl is-active --quiet gdm; then
  systemctl disable gdm
fi
if systemctl is-active --quiet lightdm; then
  systemctl disable lightdm
fi
if systemctl is-active --quiet sddm; then
  systemctl disable sddm
fi
systemctl enable cosmic-greeter

fc-cache -f /usr/share/fonts/Hack
fc-cache -f /usr/share/fonts/Inter
