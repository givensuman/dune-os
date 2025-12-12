#!/bin/bash

echo "::group:: ===$(basename "$0")==="

set -ouex pipefail

# Clean up temporary files and caches
rm -rf /tmp/* || true
rm -rf /var/tmp/* || true
rm -rf /var/log/*
rm -rf /var/lib/dnf5/*
rm -rf /var/cache/dnf5/* || true

# Clean up any leftover build artifacts
rm -rf /tmp/akmods* || true

# Clean package manager cache
dnf5 clean all

# Clean /var directory while preserving essential files
find /var/* -maxdepth 0 -type d \! -name cache -exec rm -fr {} \;
find /var/cache/* -maxdepth 0 -type d \! -name libdnf5 \! -name rpm-ostree -exec rm -fr {} \;

# Restore and setup directories
mkdir -p /var/tmp
chmod -R 1777 /var/tmp

# Commit and lint container
ostree container commit
bootc container lint

echo "::endgroup::"
