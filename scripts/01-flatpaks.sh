#!/bin/bash

set -ouex pipefail

flatpak remote-delete flathub --force
flatpak remote-delete cosmic --force

flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak remote-add --user --if-not-exists cosmic https://apt.pop-os.org/cosmic/cosmic.flatpakrepo
