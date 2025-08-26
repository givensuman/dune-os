#!/bin/bash

set -ouex pipefail

tar -xzf /fonts/Inter.tar.gz -C ~/.local/share/fonts
tar -xzf /fonts/Hack.tar.gz -C ~/.local/share/fonts

rm -rf /fonts
