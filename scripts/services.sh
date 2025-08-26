#!/bin/bash

set -ouex pipefail

systemctl disable gdm || true
systemctl disable sddm || true
systemctl enable cosmic-greeter

systemctl enable brew-dir-fix.service
systemctl enable brew-setup.service
systemctl disable brew-upgrade.timer
systemctl disable brew-update.timer

systemctl --global enable podman.socket
systemctl enable docker.socket
groupadd docker
usermod -aG docker $USER
