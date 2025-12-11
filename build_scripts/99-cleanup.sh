#!/bin/bash

echo "::group:: ===$(basename "$0")==="

set -ouex pipefail

dnf5 clean all

# Clean up temporary files and caches
rm -rf /tmp/* || true
rm -rf /var/tmp/* || true
rm -rf /var/log/*
rm -rf /var/lib/dnf5/*
rm -rf /var/cache/dnf5/* || true

# Clean up any leftover build artifacts
rm -rf /tmp/akmods* || true

echo "::endgroup::"
