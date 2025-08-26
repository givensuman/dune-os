#!/bin/bash

set -ouex pipefail

tar -xzf /fonts/*.tar.gz ~/.local/share/fonts

rm -rf /fonts
