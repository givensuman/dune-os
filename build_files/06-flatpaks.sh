#!/usr/bin/bash

echo "::group:: ===$(basename "$0")==="

set -eoux pipefail

flatpak remote-delete flathub --force || true
flatpak remote-delete cosmic --force || true

# Setup flatpak remote
flatpak remote-add --system --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak remote-add --system --if-not-exists cosmic https://apt.pop-os.org/cosmic/cosmic.flatpakrepo

# Install flatpaks during build
flatpak_refs=()

# Read main flatpak list
while IFS= read -r line; do
    [[ -z "$line" ]] && continue
    flatpak_refs+=("$line")
done < /etc/ublue-os/system-flatpaks.list

# Install flatpaks
flatpak install --system -y "${flatpak_refs[@]}"

echo "::endgroup::"
