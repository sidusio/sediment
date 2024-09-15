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
