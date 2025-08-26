#!/bin/bash

set -ouex pipefail

dnf5 -y install ublue-brew

curl -Lo /usr/share/bash-prexec \
https://raw.githubusercontent.com/ublue-os/bash-preexec/master/bash-preexec.sh
