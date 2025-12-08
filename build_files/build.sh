#!/usr/bin/bash

echo "::group:: ===$(basename "$0")==="

set -eoux pipefail

# Run build scripts
/ctx/build_files/00-image-info.sh
/ctx/build_files/03-install-kernel-akmods.sh
/ctx/build_files/04-packages.sh
/ctx/build_files/05-cosmic.sh
/ctx/build_files/06-flatpaks.sh
/ctx/build_files/07-ublue.sh
/ctx/build_files/08-firmware.sh
/ctx/build_files/97-systemd.sh
/ctx/build_files/98-initramfs.sh
/ctx/build_files/99-cleanup.sh

ostree container commit

echo "::endgroup::"
