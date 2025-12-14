#!/usr/bin/bash

echo "::group:: ===$(basename "$0")==="

set -eoux pipefail

flatpak remote-delete flathub --force || true
flatpak remote-delete cosmic --force || true

# Setup flatpak remote
flatpak remote-add --system --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak remote-add --system --if-not-exists cosmic https://apt.pop-os.org/cosmic/cosmic.flatpakrepo

dnf5 -y install ublue-os-flatpak

# Prefer firefox flatpak
if rpm -q firefox >/dev/null; then
  dnf5 -y remove firefox
fi
if rpm -q firefox-langpacks >/dev/null; then
  dnf5 -y remove firefox-langpacks
fi

echo "::endgroup::"
