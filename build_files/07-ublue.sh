#!/usr/bin/bash

echo "::group:: ===$(basename "$0")==="

set -ouex pipefail

dnf5 -y copr enable ublue-os/packages
dnf5 -y copr enable ublue-os/staging

dnf5 -y install ublue-brew
dnf5 -y install ublue-os-media-automount-udev

systemctl --global enable podman.socket

curl -Lo /usr/share/bash-prexec \
  https://raw.githubusercontent.com/ublue-os/bash-preexec/master/bash-preexec.sh || {
  echo "Failed to download bash-prexec"
  exit 1
}

if systemctl cat -- uupd.timer &>/dev/null; then
  systemctl --global enable uupd.timer
else
  systemctl --global enable rpm-ostreed-automatic.timer
  systemctl --global enable flatpak-system-update.timer
  systemctl --global enable flatpak-user-update.timer
fi

# Disable COPRs and RPM Fusion Repos
dnf5 -y copr disable ublue-os/staging
dnf5 -y copr disable ublue-os/packages
dnf5 -y copr disable phracek/PyCharm

dnf5 config-manager setopt negativo17-fedora-multimedia.enabled=0
dnf5 config-manager setopt _copr_ublue-os-akmods.enabled=0
dnf5 config-manager setopt fedora-cisco-openh264.enabled=0

dnf5 config-manager setopt rpmfusion-nonfree-nvidia-driver.enabled=0
dnf5 config-manager setopt rpmfusion-nonfree-steam.enabled=0
# Or, as fallback
for i in /etc/yum.repos.d/rpmfusion-*; do
  sed -i 's@enabled=1@enabled=0@g' "$i"
done

# Move directories from /var/opt to /usr/lib/opt
for dir in /var/opt/*/; do
  [ -d "$dir" ] || continue
  dirname=$(basename "$dir")
  mv "$dir" "/usr/lib/opt/$dirname"
  echo "L+ /var/opt/$dirname - - - - /usr/lib/opt/$dirname" >>/usr/lib/tmpfiles.d/dune-opt-fix.conf
done

# More overrides
if [ -f "/sysctl.conf" ]; then
  mkdir -p /etc/default
  mkdir -p /etc/systemd
  mkdir -p /etc/udev
  mv /default/* /etc/default
  mv /systemd/* /etc/systemd
  mv /udev/* /etc/udev
  mv sysctl.conf /etc
fi

# Import Justfile
echo "import \"/usr/share/dune-os/just/dune.just\"" >>/usr/share/ublue-os/justfile

echo "::endgroup::"
