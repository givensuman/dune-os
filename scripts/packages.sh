#!/bin/bash

set -ouex pipefail

curl -fsSL https://github.com/terrapkg/subatomic-repos/raw/main/terra.repo | pkexec tee /etc/yum.repos.d/terra.repo
dnf5 -y install terra-release

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
