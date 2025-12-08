#!/usr/bin/bash

echo "::group:: ===$(basename "$0")==="

set -eoux pipefail

# Enable services
systemctl --global enable dconf-update.service
systemctl --global enable flatpak-preinstall.service
systemctl --global enable ublue-fix-hostname.service
systemctl --global enable ublue-guest-user.service
# Stellarite patches for brew
systemctl --global enable brew-dir-fix.service
systemctl --global enable brew-setup.service
systemctl disable brew-upgrade.timer
systemctl disable brew-update.timer

echo "::endgroup::"
