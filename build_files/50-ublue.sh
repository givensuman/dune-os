#!/usr/bin/bash

echo "::group:: ===$(basename "$0")==="

set -ouex pipefail

dnf5 -y copr enable ublue-os/packages
dnf5 -y copr enable ublue-os/staging

dnf5 -y group install development-tools
dnf5 -y group install development-libraries
dnf5 -y install ublue-os-media-automount-udev

systemctl --global enable podman.socket || true
systemctl --global enable podman-auto-update.timer || true

curl -Lo /usr/share/bash-prexec \
  https://raw.githubusercontent.com/ublue-os/bash-preexec/master/bash-preexec.sh || {
  echo "Failed to download bash-prexec"
  exit 1
}

if systemctl cat -- uupd.timer &>/dev/null; then
  systemctl enable uupd.timer || true
else
  systemctl enable rpm-ostreed-automatic.timer || true
  systemctl enable flatpak-system-update.timer || true
fi

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
