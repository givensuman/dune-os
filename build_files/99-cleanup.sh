#!/bin/bash

echo "::group:: ===$(basename "$0")==="

set -ouex pipefail

dnf5 clean all

rm -rf /tmp/* || true
rm -rf /var/log/*
rm -rf /var/lib/dnf5/*
