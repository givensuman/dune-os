#!/bin/bash

set -ouex pipefail

# Remove Fedora remote and prefer Flathub
# Fedora remote seems to break `cosmic-store`
systemctl disable flatpak-add-fedora-repos.service
flatpak remote-delete flathub --force
flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak remote-add --user --if-not-exists cosmic https://apt.pop-os.org/cosmic/cosmic.flatpakrepo
