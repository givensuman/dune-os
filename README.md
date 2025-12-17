<div align="center">
  <img src="./assets/readme_header.png" />
  <!-- -->
  <img src="https://img.shields.io/github/actions/workflow/status/givensuman/dune-os/build.yml?labelColor=purple" />
  <img src="https://img.shields.io/github/actions/workflow/status/givensuman/dune-os/build_iso.yml?label=build%20iso&labelColor=blue" />
  <img src="https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/dune-os" />
</div>

## About

This is a custom Linux build designed around Fedora's [Atomic Desktops](https://fedoraproject.org/atomic-desktops/), as a community-driven adaptation of the [Universal Blue](https://universal-blue.org/) project. These systems are immutable by nature, which means users are actually gated from directly modifying the system, providing an incredibly secure form of interacting with the Linux platform.

This is the OS I use daily on a Framework 13 laptop. It features the [COSMIC desktop environment](https://system76.com/cosmic/) with a focus on containerized development. It's unopinionated by design, other than preferring [Ghostty](https://ghostty.org/) over `cosmic-term` for the terminal, and [Catppuccin](https://catppuccin.com/) for the system theme.

If you'd like to use this yourself, please feel free! If you'd like to build your own, consult the [DIY](./DIY.md) document.

<div align="center">
  <img src="./assets/moebius-01.jpg" />
</div>

## Installation

Verify the image signature with `cosign`:

```bash
cosign verify --key \
https://github.com/givensuman/dune-os/raw/main/cosign.pub \
ghcr.io/givensuman/dune-os:stable
```

You can download an ISO from the latest [Github Action Build Artifact](https://github.com/givensuman/dune-os/actions/workflows/build_iso.yml). GitHub requires you be logged in to download.

Alternatively, and preferably for most users, you can rebase from any Fedora Atomic image by running the following:

```bash
sudo bootc switch --enforce-container-sigpolicy ghcr.io/givensuman/dune-os:stable
```

Dune is developed on and builds two branches: `main` and `dev`. `ghcr.io/givensuman/dune-os:stable` points to `main` builds, whereas the `dev` branch is the one I'm working off of and maybe partially broken at any given time.

![Dune OS screenshot](./assets/screenshot.png)
_Default configuration with some additional apps and the Fish shell (see: github.com/givensuman/dune-configs)_

## Post-Install

You can layer whatever core packages you like on top of this build. You might want your favorite shell:

```bash
rpm-ostree install --apply-live fish
sudo usermod -s $(which fish) $USER
```

This is also a good time to set up rootless Docker, if you're into that sort of thing:

```bash
sudo groupadd docker
sudo usermod -aG docker $USER
```

Additional system utilities are run through Just, and can be seen by running `ujust`.

## Usage

If on the off chance you're not a developer, you're all set. This system is in a lot of ways like a Chromebook, except you get to pick hardware that isn't e-waste.

For the rest of us, development will be happening inside containers. I've opted to replace Fedora's `toolbox` with a `distrobox` wrapper of the same name. Our Ghostty terminal emulator launches into this, making the transition virtually invisible. By default, this is an Ubuntu container pre-configured with [nala](https://github.com/volitank/nala), which I find to be a pretty good development setup, but it can be whatever you want! Edit or create `~/.config/dune-os/toolbox.ini` to define a [Distrobox assemble](https://distrobox.it/usage/distrobox-assemble/) configuration. Here is an example extending the base config:

```ini
[toolbox] # You can change this name if you like
include="/usr/share/dune-os/toolbox.ini" # Include allows you to build off
                                         # of another config!
additional_packages="git vim tmux nodejs"
replace=false # If set to true, this will be re-built every startup.
              # Default is false, and you should probably keep it that way.
```

Your `toolbox.ini` is built via `systemd` on startup. You can actually define an arbitrary amount of containers to be built here, but the first one specified as an entry is the one you will launch into.

Here is a slightly more advanced template setup using Arch Linux and the [yay](https://github.com/Jguer/yay) AUR utility. Place this in `~/.config/dune-os/toolbox.ini`:

```ini
[toolbox]
image=arch:latest
additional_packages="git base-devel"
# yay can't be run as root, so we have to do a workaround
init_hooks="export USER=<your_name>;"
init_hooks="cd ~/Downloads;"
init_hooks="git clone https://aur.archlinux.org/yay.git;"
init_hooks="sudo chown -R $USER:$USER yay;"
init_hooks="sudo chmod -R 777 yay;"
init_hooks="sudo -u $USER sh -c 'cd yay && makepkg -si --noconfirm';"
init_hooks="rm -rf yay;"
pull=true
root=false
```

If you're following, this means we can run *any Linux distribution* we want, never worrying about breaking things or distro-hopping. The future is now, people.

<div align="center">
  <img src="./assets/moebius-02.jpg" />
</div>

## Secure Boot

Secure Boot is enabled by default on Universal Blue builds, adding an extra layer of security. During the initial installation, you will be prompted to enroll the secure boot key in the BIOS. To do so, enter the password `universalblue` when asked.

If this step is skipped during setup, you can manually enroll the key by running the following command in the terminal:

```
ujust enroll-secure-boot-key
```

Secure Boot works with Universal Blue's custom key, which can be found in the root of the akmods repository [here](https://github.com/ublue-os/akmods/raw/main/certs/public_key.der).
To enroll the key before installation or rebase, download the key and run:

```bash
sudo mokutil --timeout -1
sudo mokutil --import public_key.der
```

## Issues

For issues with the images, feel free to submit an issue in this repository. For COSMIC related issues, please see [cosmic-epoch/issues](https://github.com/pop-os/cosmic-epoch/issues).

## Acknowledgments

Default wallpaper designed by [Milad Fakurian](https://unsplash.com/@fakurian).

Artwork is by Jean "Moebius" Giraud.

## See Also

Intitial interest and some `systemd` patches:

- [ublue-os/bluefin](github.com/ublue-os/bluefin)

Bulk of CI/CD workflows:

- [noelmiller/isengard](https://github.com/noelmiller/isengard)

Interesting projects I stole bits and pieces from:

- [astrovm/amyos](https://github.com/astrovm/amyos)

- [m2Giles/m2os](https://github.com/m2Giles/m2os)

---

<div align="center">
  <img src="./assets/readme_footer.png" />
</div>
