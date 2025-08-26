#!/bin/bash

set -ouex pipefail

dnf5 -y config-manager setopt "terra".enabled=true

packages=(
    ffmpeg
    ghostty
    git
    vlc
    zsh
    docker-ce
    docker-ce-cli
    containerd.io
    docker-buildx-plugin
    docker-compose-plugin
)

dnf5 -y install ${packages[@]}

chsh -s $(which zsh)
