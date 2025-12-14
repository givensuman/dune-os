This document aims to guide you through setting up your own spin of a Universal Blue OS. You can also consult Universal Blue's [image template](https://github.com/ublue-os/image-template) which does a pretty good job documenting this stuff.

<img src="./assets/moebius-03.jpg" />

## Repository Setup

First things first, go ahead and [fork](https://github.com/givensuman/dune-os/fork) this repository.

Enable GitHub Actions in your repository settings, and create a variable `SIGNING_SECRET` which will hold the private end of your security key.

![](./assets/settings_dashboard.png)
_GitHub repository settings dashboard_

To obtain a key, use the [cosign](https://github.com/sigstore/cosign) tool. `cosign generate-key-pair` will dump a `cosign.pub` and `cosign.key` file; commit `cosign.pub` into git history and the contents of `cosign.key` go into the `SIGNING_SECRET` variable.

## Configuring

Your new OS gets built from its [Containerfile](./Containerfile), inside of which we run the contents of the `build_files` directory. Our scripts do most of the leg work, but we can also add content through the `system_files` directory. Universal Blue images will essentially flat-merge these files into the system.

During the build process the system is not yet set to read-only, so we can do anything outside of userland. That means `dnf` will suffice for installing packages.

System `flatpaks` can be designated using [flatpak-preinstall](https://www.mankier.com/1/flatpak-preinstall). This is a useful way of assigning "default apps" for the OS. In the case of Dune, this is basically [GNOME applications](./system_files/usr/share/flatpak/preinstall.d/gnome.preinstall).

Now we need to configure userland. You can do this via `systemd`. This will allow us to create "oneshot" services which run on first setup of the system. There are examples of this in the [`/lib/systemd`](./system_files/usr/lib/systemd/system) directory. Alternatively, and more conventionally, you can edit `/usr/share/ublue-os/justfile` to define Justfile scripts users can choose to run on their own.

And that's about it! Go nuts.

## Things You Probably Want To Change

This list is not comprehensive and in my experience building your own OS will take time and trial-and-error.

- Run a `grep` search on "dune", "dune-os", etc. and replace with your new OS's name.

- Revise [`packages.sh`](./build_files/01-packages.sh) and [`desktop.sh`](./build_files/02-desktop.sh) to your liking. Note any changes you make may have cascading results; e.g. removing the `iwd` package from being installed will break WiFi unless you also remove [`NetworkManager/conf.d/iwd.conf`](./system_files/etc/NetworkManager/conf.d/iwd.conf).

- Look through [`/usr/share/`](./system_files/usr/share/), in particular the `dune-os` and `flatpak` subdirectories.

- Revise `systemd` services in [`/usr/lib/systemd/system/`](./system_files/usr/lib/systemd/system/), and their enabling in [`systemd.sh`](./build_files/51-systemd.sh).

- Tweak the custom boot splash in [`/usr/share/plymouth/themes/spinner`](./system_files/usr/share/plymouth/themes/spinner) to your needs.

## I Broke It

No you didn't, it's virtually impossible to break an atomic OS. If you're locked out, your GRUB will hold the entry of the last working version to boot to. Once you're back in, run `rpm-ostree rollback` to undo broken changes.

If you're not locked out but you broke something else (e.g. WiFi), run `rpm-ostree usroverlay` to create a read-write layer over your system and work from there.

<img src="./assets/moebius-04.jpg" />
