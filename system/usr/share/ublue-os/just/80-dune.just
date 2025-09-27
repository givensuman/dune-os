setup-flatpaks:
    #!/bin/bash
    set -ouex pipefail

    echo "Setting up Flatpaks..."

    @flatpak update --appstream
    @flatpak update -y

    # Prefer Flatpak version of Firefox
    if rpm -q firefox; then
        @rpm-ostree -y remove firefox
    fi

    if rpm -q firefox-langpacks; then
        @rpm-ostree -y remove firefox-langpacks
    fi

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

      # Prefer Flatpak version of Firefox
      app/org.mozilla.firefox
    )

    @mkdir -p /root/.local

    for PKG in "${flatpaks[@]}"; do
      @flatpak install --user flathub "$PKG"
    done


setup-rootless-docker:
    #!/bin/bash
    set -ouex pipefail

    if [ "$EUID" -ne 0 ]; then
      @echo "Please run as root"
      @exit 1
    fi

    @echo "Setting up rootless Docker..."

    if [[ ! getent group docker ]]; then
      @sudo groupadd docker
    fi
    @sudo usermod -aG docker "$USER"

setup-virtualization:
    #!/bin/bash
    set -ouex pipefail

    if [ "$EUID" -ne 0 ]; then
      @echo "Please run as root"
      @exit 1
    fi


    # Install virtualization packages
    rpm-ostree -y install \
      libvirt \
      libvirt-client \
      # @virtualization group
      virt-install \
      libvirt-daemon-config-network \
      libvirt-daemon-kvm \
      qemu-kvm \
      virt-manager \
      virt-viewer \
      guestfs-tools \
      python3-libguestfs \
      virt-top

    flatpak install flathub org.virt_manager.virt-manager

    systemctl enable libvirtd.service

    # Compile and install SELinux policy module for virt-manager
    cp /usr/share/ublue-os/selinux/virtmanager.te /tmp
    checkmodule -M -m -o /tmp/virtmanager.mod /tmp/virtmanager.te
    semodule_package -o /tmp/virtmanager.pp -m /tmp/virtmanager.mod
    sudo semodule -i /tmp/virtmanager.pp

    rm -f /tmp/virtmanager.*

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

    rpm-ostree -y install fish
    usermod -s $(which fish) $USER

    bat cache --build
    mise install
