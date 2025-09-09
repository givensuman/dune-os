#!/bin/bash

set -ouex pipefail

systemctl disable gdm.service

dnf5 -y swap @gnome-desktop @cosmic-desktop

systemctl enable cosmic-greeter.service

fc-cache -f /usr/share/fonts/Hack
fc-cache -f /usr/share/fonts/Inter

# Fixes an issue rebasing from Silverblue-41
grep -E '^greetd:' /usr/etc/passwd | tee -a /etc/passwd
grep -E '^cosmic-greeter:' /usr/etc/passwd | tee -a /etc/passwd
grep -E '^greetd:' /usr/etc/group | tee -a /etc/group
grep -E '^cosmic-greeter:' /usr/etc/group | tee -a /etc/group
