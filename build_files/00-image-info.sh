#!/usr/bin/bash

echo "::group:: ===$(basename "$0")==="

set -eoux pipefail

# Generate image info
echo "Building Image..."
echo "Version: ${VERSION:-unknown}"
echo "Kernel: ${KERNEL:-unknown}"
echo "Fedora: ${FEDORA_MAJOR_VERSION:-unknown}"

echo "::endgroup::"
