#!/usr/bin/bash

echo "::group:: ===$(basename "$0")==="

set -eoux pipefail

# Enable services
systemctl --global enable dconf-update.service
systemctl --global enable flatpak-preinstall.service
systemctl --global enable dune-cosmic-config.service
systemctl --global enable dune-ghostty-config.service
# Bluefin patches
systemctl --global enable ublue-fix-hostname.service
systemctl --global enable ublue-guest-user.service
# Stellarite patches
systemctl --global enable brew-fix-directory.service
systemctl --global enable brew-setup.service
systemctl disable brew-upgrade.timer
systemctl disable brew-update.timer

echo "::endgroup::"
