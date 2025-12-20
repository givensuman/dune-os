#!/usr/bin/bash

echo "::group:: ===$(basename "$0")==="

set -euox pipefail

mkdir -p /etc/distrobox/

images=(
  arch
  debian
  fedora
  ubuntu
)

for image in "${images[@]}"; do
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

dnf5 -y remove toolbox

# Install dune-toolbox
git clone https://github.com/givensuman/dune-toolbox /tmp/dune-toolbox
chmod +x /tmp/dune-toolbox/scripts/install.sh
/tmp/dune-toolbox/scripts/install.sh

echo "::endgroup::"
