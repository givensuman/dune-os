#!/bin/bash

set -ouex pipefail

shopt -s extglob
dnf5 clean all

rm -rf /tmp/* || true
rm -rf /var/!(cache)
rm -rf /var/cache/!(rpm-ostree)
rm -rf /scripts

setenforce 1 || true
