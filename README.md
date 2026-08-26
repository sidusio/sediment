# Sediment

[![build-ublue](https://github.com/sidusIO/sediment/actions/workflows/build.yml/badge.svg)](https://github.com/sidusIO/sediment/actions/workflows/build.yml)

Sediment is an immutable desktop operating system built with [rpm-ostree](https://coreos.github.io/rpm-ostree/) and based on [Fedora Atomic Desktops - Sway](https://fedoraproject.org/atomic-desktops/sway/). It provides a modern, tiling window manager experience with carefully curated tools and configurations for development and daily use.

## ✨ Features

- **Immutable OS**: Built on rpm-ostree for reliable, atomic updates
- **Sway Window Manager**: Efficient tiling Wayland compositor
- **GDM Display Manager**: GNOME Display Manager replacing SDDM for better integration
- **Fish Shell**: Modern shell set as default (`/usr/bin/fish`)
- **Docker Support**: Pre-installed and configured Docker CE
- **Distrobox**: Easy container-based development environments
- **Automatic Updates**: System updates every 6 hours via systemd timer
- **Fingerprint Authentication**: Built-in fingerprint reader support
- **Screen Capture Tools**: grim, slurp, swappy, and wf-recorder for screenshots and recordings
- **Development Tools**: Kubernetes client and essential utilities
- **Premium Fonts**: Pre-installed Google Fonts (Roboto, Open Sans) and Nerd Fonts (FiraCode, Hack, SourceCodePro, Terminus, JetBrainsMono)

## 📦 Installation

### Option 1: Install from ISO

1. Download the latest ISO from the [auto-iso release](https://github.com/sidusIO/sediment/releases/tag/auto-iso)
2. Create a bootable USB drive using tools like [Fedora Media Writer](https://flathub.org/apps/org.fedoraproject.MediaWriter) or `dd`
3. Boot from the USB and follow the installation wizard

### Option 2: Rebase from Existing Fedora Atomic Installation

If you're already running a Fedora Atomic variant, you can rebase to Sediment:

1. **Rebase to unsigned image** (to install signing keys):
   ```bash
   rpm-ostree rebase ostree-unverified-registry:ghcr.io/sidusIO/sediment:latest
   ```

2. **Reboot**:
   ```bash
   systemctl reboot
   ```

3. **Rebase to signed image**:
   ```bash
   rpm-ostree rebase ostree-image-signed:docker://ghcr.io/sidusIO/sediment:latest
   ```

4. **Reboot again**:
   ```bash
   systemctl reboot
   ```

## 🚀 Getting Started

### First Steps After Installation

1. **Set up fingerprint authentication** (if supported):
   ```bash
   just fingerprint
   ```

2. **Install ASDF version manager** (for managing development tool versions):
   ```bash
   just asdf
   ```
   This installs ASDF into your user space (`~/.asdf`) with Fish shell integration.

3. **Install JetBrains Toolbox** (for JetBrains IDEs):
   ```bash
   just jetbrains-toolbox
   ```

### Available Just Commands

Sediment uses [just](https://github.com/casey/just) as a command runner. Here are the custom commands available:

#### Screen Capture
```bash
# Take a screenshot and edit it in swappy
just screenshot-edit

# Take a screenshot and copy to clipboard
just screenshot

# Record screen video (saved to ~/Videos/screencapture-{timestamp}.mkv)
just screencapture
```

#### Development Tools
```bash
# Install ASDF version manager
just asdf

# Set up fingerprint authentication
just fingerprint

# Install JetBrains Toolbox
just jetbrains-toolbox
```

Run `just` without arguments to see all available commands, including those inherited from the base Fedora Atomic system.

## 🛠️ What's Included

### Pre-installed Software

- **Shell**: Fish (default shell)
- **Containers**: Docker CE, Distrobox
- **Development**: Kubernetes client (kubectl)
- **Screen Capture**: grim, slurp, swappy, wf-recorder
- **Authentication**: fprintd for fingerprint support

### Custom Configurations

- **Sway**: Custom configurations in `/usr/etc/sway/config.d/`
  - GNOME Keyring integration (95-gnome-keyring.conf)
- **Environment**: Custom environment variables in `/usr/etc/environment.d/`
  - Default shell set to Fish
  - GNOME Keyring SSH agent configuration
- **Automatic Updates**: Systemd timer runs every 6 hours after boot

### Fonts

**Google Fonts**:
- Roboto
- Open Sans

**Nerd Fonts**:
- FiraCode
- Hack
- SourceCodePro
- Terminus
- JetBrainsMono
- NerdFontsSymbolsOnly

## 🔧 Building & Development

### Prerequisites

- Podman or Buildah
- Just (command runner)

### Build the Image Locally

```bash
# Using buildah
buildah build -t sediment:local -f Containerfile .

# Using podman
podman build -t sediment:local -f Containerfile .
```

### Format Just Files

```bash
just fmt
```

### CI/CD

Sediment uses GitHub Actions for continuous integration:

- **Build Workflow**: Automatically builds and publishes container images daily at 17:00 UTC
- **ISO Release**: Generates installation ISOs and publishes them to the `auto-iso` release
- **Image Signing**: All images are signed with Cosign for verification

## 📚 Useful Links

### Project Resources
- **GitHub Repository**: [sidusIO/sediment](https://github.com/sidusIO/sediment)
- **Container Registry**: [ghcr.io/sidusio/sediment](https://ghcr.io/sidusio/sediment)
- **ISO Downloads**: [Releases](https://github.com/sidusIO/sediment/releases/tag/auto-iso)

### Upstream Projects
- **Fedora Atomic Desktops**: https://fedoraproject.org/atomic-desktops/
- **Fedora Sway Atomic**: https://fedoraproject.org/atomic-desktops/sway/
- **rpm-ostree**: https://coreos.github.io/rpm-ostree/
- **Universal Blue**: https://universal-blue.org/

### Documentation
- **Sway WM**: https://swaywm.org/
- **rpm-ostree**: https://coreos.github.io/rpm-ostree/
- **Distrobox**: https://distrobox.it/
- **Just**: https://github.com/casey/just

### Tools & Utilities
- **Fish Shell**: https://fishshell.com/
- **ASDF**: https://asdf-vm.com/
- **Docker**: https://docs.docker.com/

## 🤝 Contributing

Contributions are welcome! Feel free to:

- Open issues for bugs or feature requests
- Submit pull requests with improvements
- Share your configurations and customizations

Please ensure pull requests follow the existing code style and conventions.

## 📄 License

This project is licensed under the Apache License 2.0. See the [LICENSE](LICENSE) file for details.

## 💡 Tips & Tricks

- **Immutable OS**: Remember that `/usr` is read-only. Use `rpm-ostree install` to layer packages, or use Distrobox for development environments.
- **Updates**: Updates happen automatically, but you can manually update with `rpm-ostree update` and reboot.
- **Rollback**: If something goes wrong, rollback to the previous deployment with `rpm-ostree rollback`.
- **Layered Packages**: Check layered packages with `rpm-ostree status`.
- **Customization**: Add your own custom configurations to `/etc` (mutable) or create your own custom image based on Sediment.

## 🆘 Troubleshooting

### Fingerprint Reader Not Working
Ensure your device's fingerprint reader is supported by fprintd. Run `fprintd-list` to check available devices.

### Screen Capture Not Working
Make sure you're running under Wayland (Sway). The capture tools require Wayland.

### Docker Permission Issues
Add your user to the docker group:
```bash
sudo usermod -aG docker $USER
```
Then log out and back in for changes to take effect.

---

**Built with ❤️ using Fedora Atomic and rpm-ostree**
