#!/usr/bin/bash

echo "::group:: ===$(basename "$0")==="

set -eoux pipefail

# My patches
systemctl --global enable dconf-update.service
systemctl --global enable dune-cosmic-config.service
systemctl --global enable dune-fish-config.service
systemctl --global enable dune-ghostty-config.service
systemctl --global enable fish-default-shell.service
systemctl --global enable flatpak-preinstall.service
# Bluefin patches
systemctl --global enable ublue-fix-hostname.service
systemctl --global enable ublue-guest-user.service
# Stellarite patches
systemctl --global enable brew-fix-directory.service
systemctl --global enable brew-setup.service
systemctl --global enable brew-update.timer
systemctl --global enable brew-upgrade.timer

echo "::endgroup::"
