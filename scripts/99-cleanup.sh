#!/bin/bash

set -ouex pipefail

dnf5 clean all

rm -rf /tmp/* || true
rm -rf /var/log/*
rm -rf /var/lib/dnf5/*
rm -rf /scripts
