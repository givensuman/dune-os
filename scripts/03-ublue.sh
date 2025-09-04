#!/bin/bash

set -ouex pipefail

dnf5 -y copr enable ublue-os/packages
dnf5 -y copr enable ublue-os/staging

dnf5 -y install ublue-brew
dnf5 -y install ublue-os-media-automount-udev

systemctl --global enable podman.socket

systemctl enable brew-dir-fix.service
systemctl enable brew-setup.service
systemctl disable brew-upgrade.timer
systemctl disable brew-update.timer

curl -Lo /usr/share/bash-prexec \
  https://raw.githubusercontent.com/ublue-os/bash-preexec/master/bash-preexec.sh

if systemctl cat -- uupd.timer &>/dev/null; then
  systemctl enable uupd.timer
else
  systemctl enable rpm-ostreed-automatic.timer
  systemctl enable flatpak-system-update.timer
  systemctl --global enable flatpak-user-update.timer
fi

# Disable COPRs and RPM Fusion Repos
sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/negativo17-fedora-multimedia.repo
dnf5 -y copr disable ublue-os/staging
dnf5 -y copr disable ublue-os/packages
dnf5 -y copr disable phracek/PyCharm
sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/_copr_ublue-os-akmods.repo
sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/fedora-cisco-openh264.repo
for i in /etc/yum.repos.d/rpmfusion-*; do
  sed -i 's@enabled=1@enabled=0@g' "$i"
done
