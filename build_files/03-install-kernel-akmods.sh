#!/usr/bin/bash

echo "::group:: ===$(basename "$0")==="

set -eoux pipefail

# Remove Existing Kernel
for pkg in kernel kernel-core kernel-modules kernel-modules-core kernel-modules-extra; do
    rpm --erase $pkg --nodeps
done

# Fetch Common AKMODS & Kernel RPMS
skopeo copy --retry-times 3 docker://ghcr.io/ublue-os/akmods:"${AKMODS_FLAVOR}"-"$(rpm -E %fedora)"-"${KERNEL}" dir:/tmp/akmods
AKMODS_TARGZ=$(jq -r '.layers[].digest' </tmp/akmods/manifest.json | cut -d : -f 2)
tar -xvzf /tmp/akmods/"$AKMODS_TARGZ" -C /tmp/
mv /tmp/rpms/* /tmp/akmods/

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
if [[ "${UBLUE_IMAGE_TAG}" == "beta" ]]; then
    dnf5 -y install /tmp/akmods/kmods/*xone*.rpm || true
    dnf5 -y install /tmp/akmods/kmods/*openrazer*.rpm || true
    dnf5 -y install /tmp/akmods/kmods/*framework-laptop*.rpm || true
    dnf5 -y install \
        https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-"$(rpm -E %fedora)".noarch.rpm || true
    dnf5 -y install \
        https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-"$(rpm -E %fedora)".noarch.rpm || true
    dnf5 -y install \
        v4l2loopback /tmp/akmods/kmods/*v4l2loopback*.rpm || true
    dnf5 -y remove rpmfusion-free-release || true
    dnf5 -y remove rpmfusion-nonfree-release || true
else
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
fi

# ZFS for gts/stable
if [[ ${AKMODS_FLAVOR} =~ coreos ]]; then
    # Fetch ZFS RPMs
    skopeo copy --retry-times 3 docker://ghcr.io/ublue-os/akmods-zfs:"${AKMODS_FLAVOR}"-"$(rpm -E %fedora)"-"${KERNEL}" dir:/tmp/akmods-zfs
    ZFS_TARGZ=$(jq -r '.layers[].digest' </tmp/akmods-zfs/manifest.json | cut -d : -f 2)
    tar -xvzf /tmp/akmods-zfs/"$ZFS_TARGZ" -C /tmp/
    mv /tmp/rpms/* /tmp/akmods-zfs/

    # Declare ZFS RPMs
    ZFS_RPMS=(
        /tmp/akmods-zfs/kmods/zfs/kmod-zfs-"${KERNEL}"-*.rpm
        /tmp/akmods-zfs/kmods/zfs/libnvpair3-*.rpm
        /tmp/akmods-zfs/kmods/zfs/libuutil3-*.rpm
        /tmp/akmods-zfs/kmods/zfs/libzfs6-*.rpm
        /tmp/akmods-zfs/kmods/zfs/libzpool6-*.rpm
        /tmp/akmods-zfs/kmods/zfs/python3-pyzfs-*.rpm
        /tmp/akmods-zfs/kmods/zfs/zfs-*.rpm
        pv
    )

    # Install
    dnf5 -y install "${ZFS_RPMS[@]}"

    # Depmod and autoload
    depmod -a -v "${KERNEL}"
    echo "zfs" >/usr/lib/modules-load.d/zfs.conf
fi

echo "::endgroup::"