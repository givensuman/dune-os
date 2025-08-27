#!/bin/bash

set -ouex pipefail

mkdir -p /etc/yum.repos.d

curl -fsSL https://github.com/terrapkg/subatomic-repos/raw/main/terra.repo | tee /etc/yum.repos.d/terra.repo
dnf5 -y install terra-release

curl -fsSL https://download.docker.com/linux/fedora/docker-ce.repo | tee /etc/yum.repos.d/docker-ce.repo

packages=(
  ghostty
  git
  vlc
  fish
  # docker-ce
  # docker-ce-cli
  # containerd.io
  # docker-buildx-plugin
  # docker-compose-plugin
)

dnf5 -y install ${packages[@]}

usermod --shell $(which fish) root

systemctl enable docker
