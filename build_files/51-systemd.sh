#!/usr/bin/bash

echo "::group:: ===$(basename "$0")==="

set -eoux pipefail

systemctl enable dconf-update.service
systemctl enable flatpak-preinstall.service
systemctl enable ublue-fix-hostname.service
systemctl enable ublue-guest-user.service

echo "::endgroup::"
