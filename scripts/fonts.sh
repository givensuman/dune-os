#!/bin/bash

set -ouex pipefail

tar -xzf /fonts/*.tar.gz -C ~/.local/share/fonts

rm -rf /fonts
