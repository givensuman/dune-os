#!/usr/bin/bash

echo "::group:: ===$(basename "$0")==="

set -eoux pipefail

# Enable services
systemctl enable rpm-ostree-countme.service
systemctl enable dconf-update.service
systemctl enable flatpak-preinstall.service
systemctl enable ublue-fix-hostname.service
systemctl enable ublue-guest-user.service
# Stellarite patches for brew
systemctl enable brew-dir-fix.service
systemctl enable brew-setup.service
systemctl disable brew-upgrade.timer
systemctl disable brew-update.timer

echo "::endgroup::"
