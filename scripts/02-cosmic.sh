#!/bin/bash

set -ouex pipefail

dnf5 -y swap @gnome-desktop @cosmic-desktop
dnf5 -y remove @gnome-desktop gnome
dnf5 -y install @cosmic-desktop

dnf5 -y install \
  gnome-software \
  gnome-keyring

systemctl disable gdm.service
systemctl enable cosmic-greeter.service

fc-cache -f /usr/share/fonts/Hack
fc-cache -f /usr/share/fonts/Inter
