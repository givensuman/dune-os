#!/usr/bin/bash

echo "::group:: ===$(basename "$0")==="

set -eoux pipefail

flatpak remote-delete flathub --force || true
flatpak remote-delete cosmic --force || true

# Setup flatpak remote
flatpak remote-add --system --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak remote-add --system --if-not-exists cosmic https://apt.pop-os.org/cosmic/cosmic.flatpakrepo

# Install flatpaks during build
flatpak_refs=(
  app/com.github.tchx84.Flatseal
  app/io.github.flattool.Warehouse
  app/org.gnome.baobab
  app/org.gnome.Calculator
  app/org.gnome.Calendar
  app/org.gnome.Characters
  app/org.gnome.clocks
  app/org.gnome.Contacts
  app/org.gnome.DejaDup
  app/org.gnome.FileRoller
  app/org.gnome.Firmware
  app/org.gnome.font-viewer
  app/org.gnome.Logs
  app/org.gnome.Loupe
  app/org.gnome.Maps
  app/org.gnome.NautilusPreviewer
  app/org.gnome.Papers
  app/org.gnome.Showtime
  app/org.gnome.SimpleScan
  app/org.gnome.Snapshot
  app/org.gnome.TextEditor
  app/org.gnome.Weather
  app/org.mozilla.firefox
  runtime/org.gtk.Gtk3theme.adw-gtk3
  runtime/org.gtk.Gtk3theme.adw-gtk3-dark
)

# Install flatpaks
flatpak install --system -y "${flatpak_refs[@]}"

echo "::endgroup::"
