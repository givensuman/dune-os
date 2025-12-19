#!/usr/bin/bash

echo "::group:: ===$(basename "$0")==="

set -eoux pipefail

mkdir -p /etc/distrobox/

images=(
  arch
  debian
  fedora
  ubuntu
)

for image in ${images[@]}; do
  tee -a /etc/distrobox/distrobox.ini << EOF
["${image}-distrobox"]
image="ghcr.io/ublue-os/${image}-toolbox:latest"
nvidia=true
entry=false
volume="/home/linuxbrew/:/home/linuxbrew:rslave"
EOF
done

tee /etc/distrobox/distrobox.conf <<EOF
container_always_pull=false
container_generate_entry=false
container_manager="podman"
distrobox_sudo_program="sudo --askpass"
EOF

echo "::endgroup::"
