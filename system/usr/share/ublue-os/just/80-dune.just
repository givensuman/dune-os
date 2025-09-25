setup-flatpaks:
    #!/bin/bash
    set -ouex pipefail

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

setup-rootless-docker:
    groupadd docker
    usermod -aG docker $USER

setup-virtualization:
    #!/bin/bash
    set -ouex pipefail

    # Install virtualization packages
    dnf5 -y install \
      libvirt \
      libvirt-client
    dnf5 -y group install \
      virtualization-client \
      virtualization-platform \
      virtualization-tools
    flatpak install flathub org.virt_manager.virt-manager

    systemctl enable libvirtd.service

    # Compile and install SELinux policy module for virt-manager
    checkmodule -M -m -o /tmp/virtmanager.mod /tmp/virtmanager.te
    semodule_package -o /tmp/virtmanager.pp -m /tmp/virtmanager.mod
    semodule -i /tmp/virtmanager.pp

setup-givens-cool-stuff:
    #!/bin/bash
    set -ouex pipefail

    git clone https://github.com/givensuman/dotfiles ~/Downloads/dotfiles
    for entry in ~/Downloads/dotfiles/*; do
      if [[ -d $entry ]]; then

    file_name=$(basename "$entry")
        mkdir -p "$HOME/.config/$file_name"
        cp -r "$entry/"* "$HOME/.config/$file_name/"
      fi
    done

    brew install \
      bat \
      eza \
      fd \
      fzf \
      gh \
      lazygit \
      mise \
      neovim \
      opencode \
      ripgrep \
      zoxide

    flatpaks=(
      app/com.discordapp.Discord
      app/de.haeckerfelix.Fragments
      app/io.github.shiftey.Desktop
      app/org.localsend.localsend_app
      app/com.spotify.Client
    )

    for PKG in "${flatpaks[@]}"; do
      flatpak install --user flathub "$PKG"
    done

    rpm-ostree install fish
    usermod -s $(which fish) $USER

    bat cache --build
    mise install
