#!/bin/bash

set -ouex pipefail

mkdir -p /etc/yum.repos.d
curl -fsSL https://github.com/terrapkg/subatomic-repos/raw/main/terra.repo | tee /etc/yum.repos.d/terra.repo
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
