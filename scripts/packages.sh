#!/bin/bash

set -ouex pipefail

mkdir -p /etc/yum.repos.d

curl -fsSL https://github.com/terrapkg/subatomic-repos/raw/main/terra.repo | tee /etc/yum.repos.d/terra.repo
dnf5 -y install terra-release

packages=(
  ghostty
  git
  vlc
)

dnf5 -y install "${packages[@]}"
