#!/bin/bash

set -ouex pipefail

# Install virtualization packages
dnf5 -y install @virt - host @virt - guest - tools
flatpak install flathub org.virt_manager.virt-manager

systemctl enable libvirtd.service

# Compile and install SELinux policy module for virt-manager
checkmodule -M -m -o /tmp/virtmanager.mod /tmp/virtmanager.te
semodule_package -o /tmp/virtmanager.pp -m /tmp/virtmanager.mod
semodule -i /tmp/virtmanager.pp
