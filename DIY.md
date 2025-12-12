This document aims to guide you through setting up your own spin of a Universal Blue OS. You can also consult Universal Blue's [image template](https://github.com/ublue-os/image-template) which does a pretty good job documenting this stuff.

<img src="./assets/moebius-03.jpg" align="center" />

## Repository Setup

First things first, go ahead and [fork](https://github.com/givensuman/dune-os/fork) this repository.

Enable GitHub Actions in your repository settings, and create a variable `SIGNING_SECRET` which will hold the private end of your security key.

![](./assets/settings_dashboard.png)
_GitHub repository settings dashboard_

To obtain a key, use the [cosign](https://github.com/sigstore/cosign) tool. `cosign generate-key-pair` will dump a `cosign.pub` and `cosign.key` file; commit `cosign.pub` into git history and the contents of `cosign.key` go into the `SIGNING_SECRET` variable.

## Configuring

Your new OS gets built from its [Containerfile](./Containerfile), inside of which we run the contents of the `build_scripts` directory. Our scripts do most of the leg work, but we can also add content through the `system_files` directory. Universal Blue images will essentially flat-merge these files into the system.

During the build process the system is not yet set to read-only, so we can do anything outside of userland. That means `dnf` will suffice for installing packages.

System `flatpaks` can be designated using [flatpak-preinstall](https://www.mankier.com/1/flatpak-preinstall). This is a useful way of assigning "default apps" for the OS. In the case of Dune, this is basically [GNOME applications](./system_files/usr/share/flatpak/preinstall.d/gnome.preinstall).

Now we need to configure userland. You can do this via `systemd`. This will allow us to create "oneshot" services which run on first setup of the system. There are examples of this in the [/lib/systemd](./system_files/usr/lib/systemd/system) directory.

And that's about it! Go nuts.

<img src="./assets/moebius-04.jpg" align="center" />
