#!/bin/bash

set -ouex pipefail

dnf5 -y remove firefox firefox-langpacks
rm -rf /usr/share/mozilla

flatpaks=(
    app/com.github.tchx84.Flatseal/x86_64/stable
    app/io.github.flattool.Warehouse/x86_64/stable
    app/io.podman_desktop.PodmanDesktop/x86_64/stable
    app/org.mozilla.firefox/x86_64/stable

    app/org.gnome.Calculator/x86_64/stable
    app/org.gnome.Calendar/x86_64/stable
    app/org.gnome.Characters/x86_64/stable
    app/org.gnome.clocks/x86_64/stable
    app/org.gnome.Contacts/x86_64/stable
    app/org.gnome.Papers/x86_64/stable
    app/org.gnome.font-viewer/x86_64/stable
    app/org.gnome.Logs/x86_64/stable
    app/org.gnome.Loupe/x86_64/stable
    app/org.gnome.Maps/x86_64/stable
    app/org.gnome.Weather/x86_64/stable
)

mkdir -p /var/roothome
flatpak --system -y install --or-update flathub ${flatpaks[@]}
