ARG BASE_IMAGE_NAME="${BASE_IMAGE_NAME:-base}"
ARG IMAGE_TAG="${IMAGE_TAG:-stable}"

FROM ghcr.io/ublue-os/${BASE_IMAGE_NAME}:${IMAGE_TAG} AS dune-os

# Copying system files into main image
COPY system /

# Setup COPR repos
RUN --mount=type=cache,dst=/var/cache/rpm-ostree \
    --mount=type=bind,from=ctx,source=/,target=/ctx \
    if [[ "${FEDORA_MAJOR_VERSION}" == "rawhide" ]]; then \
    curl -Lo /etc/yum.repos.d/_copr_ryanabx-cosmic.repo \
    https://copr.fedorainfracloud.org/coprs/ryanabx/cosmic-epoch/repo/fedora-rawhide/ryanabx-cosmic-epoch-fedora-rawhide.repo \
    ; else curl -Lo /etc/yum.repos.d/_copr_ryanabx-cosmic.repo \
    https://copr.fedorainfracloud.org/coprs/ryanabx/cosmic-epoch/repo/fedora-$(rpm -E %fedora)/ryanabx-cosmic-epoch-fedora-$(rpm -E %fedora).repo \
    ; fi && \
    mkdir -p /var/roothome && \
    dnf5 -y install dnf5-plugins && \
    for copr in \
        ublue-os/staging \
        ublue-os/packages; \
    do \
    dnf5 -y copr enable $copr; \
    dnf5 -y config-manager setopt copr:copr.fedorainfracloud.org:${copr////:}.priority=99 ;\
    done && unset -v copr && \
    dnf5 -y install --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release{,-extras} && \
    dnf5 -y install \
    https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm && \
    dnf5 -y config-manager setopt "*akmods*".priority=1 && \
    dnf5 -y config-manager setopt "*terra*".priority=2 "*terra*".exclude="nerd-fonts topgrade" && \
    dnf5 -y config-manager setopt "terra-mesa".enabled=true && \
    dnf5 -y config-manager setopt "terra-nvidia".enabled=false && \
    dnf5 -y config-manager setopt "*rpmfusion*".priority=3 "*rpmfusion*".exclude="mesa-*" && \
    dnf5 -y config-manager setopt "*fedora*".exclude="mesa-* kernel-core-* kernel-modules-* kernel-uki-virt-*" && \
    dnf5 -y config-manager setopt "*staging*".exclude="scx-scheds kf6-* mesa* mutter* rpm-ostree* systemd* \
    gnome-shell gnome-settings-daemon gnome-control-center gnome-software libadwaita tuned*" && \
    ostree container commit

# Remove stock Firefox
RUN --mount=type=cache,dst=/var/cache/rpm-ostree \
    --mount=type=bind,from=ctx,source=/,target=/ctx \
    rpm-ostree override remove \
    firefox \
    firefox-langpacks \
    || true && \
    && rm -rf /usr/share/mozilla && \
    ostree container commit

# Install additional packages
RUN --mount=type=cache,dst=/var/cache/rpm-ostree \
    --mount=type=bind,from=ctx,source=/,target=/ctx \
    rpm-ostree install \
    bat \
    eza \
    fd \
    ffmpeg \
    fzf \
    git \
    ghostty \
    nvim \
    ripgrep \
    vlc \
    zoxide \
    zsh \
    || true && \
    ostree container commit

# Install and configure Cosmic DE
RUN --mount=type=cache,dst=/var/cache/rpm-ostree \
    --mount=type=bind,from=ctx,source=/,target=/ctx \
    rpm-ostree install \
    cosmic-desktop && \
    # Install GNOME applications
    rpm-ostree install \
    gnome-software \
    gnome-disk-utility \
    gparted \
    gnome-keyring && \
    # Remove cosmic-store and replace it with gnome-software
    # as the former is currently broken in immutable systems
    rpm-ostree remove \
    cosmic-store || true && \
    ostree container commit


# Ensure Homebrew is installed
RUN --mount=type=cache,dst=/var/cache/rpm-ostree \
    --mount=type=bind,from=ctx,source=/,target=/ctx \
    dnf5 install -y ublue-brew && \
    curl -Lo /usr/share/bash-prexec https://raw.githubusercontent.com/ublue-os/bash-preexec/master/bash-preexec.sh && \
    ostree container commit

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=tmpfs,dst=/tmp \
    dnf5 install -y --enable-repo=copr:copr.fedorainfracloud.org:ublue-os:packages \
    ublue-os-media-automount-udev && \
    ostree container commit

# Finalize
COPY override /
RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    mkdir -p /var/tmp && chmod 1777 /var/tmp && \
    # Service management
    systemctl disable gdm || true && \
    systemctl disable sddm || true && \
    systemctl enable cosmic-greeter && \
    systemctl enable brew-dir-fix.service && \
    systemctl enable brew-setup.service && \
    systemctl disable brew-upgrade.timer && \
    systemctl disable brew-update.timer && \
    systemctl --global enable podman.socket && \
    # Adding good stuff
    curl -Lo /etc/dxvk-example.conf https://raw.githubusercontent.com/doitsujin/dxvk/master/dxvk.conf && \
    curl -Lo /usr/lib/sysctl.d/99-bore-scheduler.conf https://github.com/CachyOS/CachyOS-Settings/raw/master/usr/lib/sysctl.d/99-bore-scheduler.conf && \
    curl -Lo /etc/distrobox/docker.ini https://github.com/ublue-os/toolboxes/raw/refs/heads/main/apps/docker/distrobox.ini && \
    curl -Lo /etc/distrobox/incus.ini https://github.com/ublue-os/toolboxes/raw/refs/heads/main/apps/docker/incus.ini && \
    # Disabling copr for faster sync
    for repo in \
        fedora-cisco-openh264 \
        terra \
        terra-extras \
        _copr_ublue-os-akmods; \
    do \
    sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/$repo.repo; \
    done && for copr in \
        ublue-os/staging \
        ublue-os/packages; \
    do \
    dnf5 -y copr disable $copr; \
    done && unset -v copr && \
    dnf5 config-manager setopt "terra-mesa".enabled=0 && \
    sed -i 's|#default.clock.allowed-rates = \[ 48000 \]|default.clock.allowed-rates = [ 44100 48000 ]|' /usr/share/pipewire/pipewire.conf && \
    sed -i 's|^ExecStart=.*|ExecStart=/usr/libexec/rtkit-daemon --no-canary|' /usr/lib/systemd/system/rtkit-daemon.service && \
    ln -s /usr/bin/true /usr/bin/pulseaudio && \
    mkdir -p /etc/flatpak/remotes.d && \
    curl -Lo /etc/flatpak/remotes.d/flathub.flatpakrepo https://dl.flathub.org/repo/flathub.flatpakrepo && \
    mkdir -p /var/tmp && chmod 1777 /var/tmp && \
    ostree container commit
