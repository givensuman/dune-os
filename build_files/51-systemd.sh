#!/usr/bin/bash

echo "::group:: ===$(basename "$0")==="

set -eoux pipefail

systemctl --global enable dconf-update.service
systemctl --global enable flatpak-preinstall.service
systemctl --global enable ublue-fix-hostname.service
systemctl --global enable ublue-guest-user.service

echo "::endgroup::"
