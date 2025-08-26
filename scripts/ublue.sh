#!/bin/bash

set -ouex pipefail

dnf5 -y copr enable ublue-os/packages
dnf5 -y copr enable ublue-os/staging

dnf5 -y install ublue-brew
dnf5 -y install ublue-os-media-automount-udev

curl -Lo /usr/share/bash-prexec \
https://raw.githubusercontent.com/ublue-os/bash-preexec/master/bash-preexec.sh
