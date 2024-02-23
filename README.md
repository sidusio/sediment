# Sediment

[![build-ublue](https://github.com/sidusIO/sediment/actions/workflows/build.yml/badge.svg)](https://github.com/sidusIO/sediment/actions/workflows/build.yml)

Sediment is an immutable desktop OS built with [rpm-ostree](https://coreos.github.io/rpm-ostree/) and based on [Fedora Sericea](https://fedoraproject.org/atomic-desktops/sway/).

## Getting Started

To get started you can either:

### Create a new system using the ISO
No further explanation needed I hope.

### Rebase onto this image from another installation
- First rebase to the unsigned image, to get the proper signing keys and policies installed:
  ```
  rpm-ostree rebase ostree-unverified-registry:ghcr.io/sidusIO/sediment:latest
  ```
- Reboot to complete the rebase:
  ```
  systemctl reboot
  ```
- Then rebase to the signed image, like so:
  ```
  rpm-ostree rebase ostree-image-signed:docker://ghcr.io/sidusIO/sediment:latest
  ```
- Reboot again to complete the installation
  ```
  systemctl reboot
  ```

## Customization

The easiest way to start customizing is by looking at and modifying `config/recipe.yml`. It's documented using comments and should be pretty easy to understand.

If you want to add custom configuration files, you can just add them in the `/usr/etc/` directory, which is the official OSTree "configuration template" directory and will be applied to `/etc/` on boot. `config/files/usr` is copied into your image's `/usr` by default. If you need to add other directories in the root of your image, that can be done using the `files` module. Writing to `/var/` in the image builds of OSTree-based distros isn't supported and will not work, as that is a local user-managed directory!

For more information about customization, see [the README in the config directory](config/README.md)

Documentation around making custom images exists / should be written in two separate places:
* [The Tinkerer's Guide on the website](https://universal-blue.org/tinker/make-your-own/) for general documentation around making custom images, best practices, tutorials, and so on.
* Inside this repository for documentation specific to the ins and outs of the template (like module documentation), and just some essential guidance on how to make custom images.
