<img src="./assets/dune_logo.png" />

<div align="center">
  <img src="https://img.shields.io/github/actions/workflow/status/givensuman/dune-os/build.yml?labelColor=purple" />
  <img src="https://img.shields.io/github/actions/workflow/status/givensuman/dune-os/build_iso.yml?label=build%20iso&labelColor=blue" />
  <img src="https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/dune-os" />

</div>

## About

This is a custom Linux operating system designed around Fedora's [Atomic Desktops](https://fedoraproject.org/atomic-desktops/), as a community-driven adaptation of the [Universal Blue](https://universal-blue.org/) project. These systems are immutable by nature, which means users are actually gated from directly modifying the system, providing an incredibly secure form of interacting with the Linux platform.

## What's Included

- **Solid OS Core**  
  Powered by the robust [ublue-os main](https://github.com/ublue-os/main), ensuring a reliable and stable base for your system.

- **COSMIC Desktop Environment**  
  The [COSMIC Desktop Environment](https://system76.com/cosmic/) by System76 is a new and exciting addition to the Linux desktop ecosystem.

- **Flatpak Preinstalled**  
  Flatpak is preconfigured for seamless access to a vast library of applications right from the get-go.

- **Homebrew Package Manager**  
  Comes with [Homebrew](https://brew.sh/) for easy management of additional software packages.

## Installation

You can download an ISO from the latest [Github Action Build Artifact](https://github.com/givensuman/dune-os/actions/workflows/build_iso.yml). GitHub requires you be logged in to download.

Alternatively, and preferably for most users, you can rebase from any Fedora Atomic image by running the following:

```bash
rpm-ostree rebase ostree-unverified-registry:ghcr.io/givensuman/dune-os:stable
```

## Post-Install

You can layer whatever packages you like on top of this build. I recommend installing your favorite shell:

```bash
rpm-ostree install --apply-live fish
```

This is also a good time to set up Docker permissions, if you plan to use it:

```
sudo groupadd docker
sudo usermod -aG docker $USER
```

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

The idea for this atomic COSMIC-based system was inspired by the [Stellarite](https://github.com/BillyAddlers/stellarite) project. This repository is also a fork of the [Isengard](https://github.com/noelmiller/isengard) desktop. Artwork is by Jean "Moebius" Giraud.

<img src="./assets/dune_footer.png" />
