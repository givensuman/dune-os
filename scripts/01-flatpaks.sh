#!/bin/bash

set -ouex pipefail

flatpak remote-add --system --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
systemctl disable flatpak-add-fedora-repos.service

dnf5 -y remove firefox firefox-langpacks
rm -rf /usr/share/mozilla

flatpaks=(
  app/com.github.tchx84.Flatseal
  app/io.github.flattool.Warehouse
  app/io.github.flattool.Ignition
  app/io.github.flattool.Warehouse
  app/io.gitlab.adhami3310.Impression
  app/io.missioncenter.MissionCenter

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
  app/org.gnome.Weather
  app/org.gnome.clocks
  app/org.gnome.font-viewer

  app/io.podman_desktop.PodmanDesktop
  app/org.mozilla.firefox
)

mkdir -p /var/roothome
flatpak --system -y install --or-update flathub "${flatpaks[@]}"
