#!/bin/bash

set -ouex pipefail

if [[ "${FEDORA_MAJOR_VERSION}" == "rawhide" ]]; then
    curl -Lo /etc/yum.repos.d/_copr_ryanabx-cosmic.repo \
    https://copr.fedorainfracloud.org/coprs/ryanabx/cosmic-epoch/repo/fedora-rawhide/ryanabx-cosmic-epoch-fedora-rawhide.repo
else
    curl -Lo /etc/yum.repos.d/_copr_ryanabx-cosmic.repo \
    https://copr.fedorainfracloud.org/coprs/ryanabx/cosmic-epoch/repo/fedora-$(rpm -E %fedora)/ryanabx-cosmic-epoch-fedora-$(rpm -E %fedora).repo
fi

dnf copr enable ryanabx/cosmic-epoch
dnf5 -y install cosmic-desktop

# Install GNOME applications
dnf5 -y install \
    gnome-software \
    gnome-disk-utility \
    gparted \
    gnome-keyring
# Remove cosmic-store and replace it with gnome-software
# as the former is currently broken in immutable systems
dnf5 -y remove cosmic-store
