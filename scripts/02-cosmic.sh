#!/bin/bash

set -ouex pipefail

dnf5 -y swap @gnome-desktop @cosmic-desktop
dnf5 -y remove @gnome-desktop gnome # Redundant
dnf5 -y install @cosmic-desktop     # Redundant

systemctl disable gdm.service # Redundant
systemctl enable cosmic-greeter.service

fc-cache -f /usr/share/fonts/Hack
fc-cache -f /usr/share/fonts/Inter
