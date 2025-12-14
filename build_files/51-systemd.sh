#!/usr/bin/bash

echo "::group:: ===$(basename "$0")==="

set -eoux pipefail

# My patches
systemctl enable bash-config-setup.service
systemctl enable dconf-update.service
systemctl enable dune-cosmic-config.service
systemctl enable dune-fish-config.service
systemctl enable dune-ghostty-config.service
systemctl enable flatpak-preinstall.service
# Bluefin patches
systemctl enable ublue-fix-hostname.service
systemctl enable ublue-guest-user.service
# Stellarite patches
systemctl enable brew-fix-directory.service
systemctl enable brew-setup.service
systemctl enable brew-update.timer
systemctl enable brew-upgrade.timer

echo "::endgroup::"
