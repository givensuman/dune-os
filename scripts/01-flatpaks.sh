#!/bin/bash

set -ouex pipefail

# Remove Fedora remote and prefer Flathub
# Fedora remote seems to break `cosmic-store`
systemctl disable flatpak-add-fedora-repos.service
flatpak remote-delete flathub --force
flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak update --appstream
flatpak update -y

# Prefer Flatpak version of Firefox
dnf5 -y remove firefox firefox-langpacks
rm -rf /usr/share/mozilla

flatpaks=(
  # Useful for atomic systems
  app/com.github.tchx84.Flatseal
  app/io.github.flattool.Warehouse
  app/io.github.flattool.Ignition
  app/io.github.flattool.Warehouse
  app/io.gitlab.adhami3310.Impression
  app/io.missioncenter.MissionCenter
  app/io.podman_desktop.PodmanDesktop

  # GNOME goodies
  app/org.gnome.Calculator
  app/org.gnome.Calendar
  app/org.gnome.Characters
  app/org.gnome.Connections
  app/org.gnome.Contacts
  app/org.gnome.FileRoller
  app/org.gnome.Firmware
  app/org.gnome.Logs
  app/org.gnome.Loupe
  app/org.gnome.Maps
  app/org.gnome.Papers
  app/org.gnome.SimpleScan
  app/run org.gnome.Snapshot
  app/org.gnome.Weather
  app/org.gnome.clocks
  app/org.gnome.font-viewer

  # Opinionated additions
  app/org.mozilla.firefox
)

mkdir -p /root/.local

for PKG in "${flatpaks[@]}"; do
  flatpak install --user flathub "$PKG"
done
