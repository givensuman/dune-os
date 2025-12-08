#!/usr/bin/bash

echo "::group:: ===$(basename "$0")==="

set -eoux pipefail

# Remove Existing Kernel
for pkg in kernel kernel-core kernel-modules kernel-modules-core kernel-modules-extra; do
  rpm --erase $pkg --nodeps
done

# Fetch Common AKMODS & Kernel RPMS
AKMODS_DIR="/tmp/akmods"
skopeo copy --retry-times 3 "docker://ghcr.io/ublue-os/akmods:coreos-stable-$(rpm -E %fedora)" dir:$AKMODS_DIR
AKMODS_TARGZ=$(jq -r '.layers[].digest' <$AKMODS_DIR/manifest.json | cut -d : -f 2)
tar -xvzf $AKMODS_DIR/"$AKMODS_TARGZ" -C /tmp/
mv /tmp/rpms/* $AKMODS_DIR/

# Install Kernel
dnf5 -y install \
  /tmp/kernel-rpms/kernel-[0-9]*.rpm \
  /tmp/kernel-rpms/kernel-core-*.rpm \
  /tmp/kernel-rpms/kernel-modules-*.rpm

dnf5 -y install \
  /tmp/kernel-rpms/kernel-devel-*.rpm

dnf5 versionlock add kernel kernel-devel kernel-devel-matched kernel-core kernel-modules kernel-modules-core kernel-modules-extra

sed -i 's@enabled=0@enabled=1@g' /etc/yum.repos.d/_copr_ublue-os-akmods.repo

# RPMFusion-dependent AKMODS
dnf5 -y install \
  /tmp/akmods/kmods/*xone*.rpm \
  /tmp/akmods/kmods/*openrazer*.rpm \
  /tmp/akmods/kmods/*framework-laptop*.rpm
dnf5 -y install \
  https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-"$(rpm -E %fedora)".noarch.rpm \
  https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-"$(rpm -E %fedora)".noarch.rpm
dnf5 -y install \
  v4l2loopback /tmp/akmods/kmods/*v4l2loopback*.rpm
dnf5 -y remove rpmfusion-free-release rpmfusion-nonfree-release

# Declare ZFS RPMs
ZFS_RPMS=(
  /tmp/akmods/kmods/zfs/kmod-zfs-*.rpm
  /tmp/akmods/kmods/zfs/libnvpair3-*.rpm
  /tmp/akmods/kmods/zfs/libuutil3-*.rpm
  /tmp/akmods/kmods/zfs/libzfs6-*.rpm
  /tmp/akmods/kmods/zfs/libzpool6-*.rpm
  /tmp/akmods/kmods/zfs/python3-pyzfs-*.rpm
  /tmp/akmods/kmods/zfs/zfs-*.rpm
  pv
)

# Install
for RPM in "${ZFS_RPMS[@]}"; do
  if [[ -f $RPM ]]; then
    dnf5 -y install "$RPM"
  fi
done

# Depmod and Autoload
depmod -a -v "$(rpm -q kernel --qf '%{version}-%{release}.%{arch}')"
echo "zfs" >/usr/lib/modules-load.d/zfs.conf

echo "::endgroup::"

