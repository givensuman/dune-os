#!/bin/bash

set -ouex pipefail

dnf5 -y swap @gnome-desktop @cosmic-desktop

systemctl enable cosmic-greeter.service

fc-cache -f /usr/share/fonts/Hack
fc-cache -f /usr/share/fonts/Inter
