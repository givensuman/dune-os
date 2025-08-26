#!/bin/bash

set -ouex pipefail


curl -Lo /etc/yum.repos.d/_copr_ryanabx-cosmic.repo \
https://copr.fedorainfracloud.org/coprs/ryanabx/cosmic-epoch/repo/fedora-$(rpm -E %fedora)/ryanabx-cosmic-epoch-fedora-$(rpm -E %fedora).repo

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
