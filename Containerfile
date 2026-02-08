ARG OS_VERSION=43

FROM quay.io/fedora-ostree-desktops/sway-atomic:$OS_VERSION

ARG OS_VERSION
ENV OS_VERSION=$OS_VERSION

ARG GITHUB_SHA
ENV GITHUB_SHA=$GITHUB_SHA

ARG GITHUB_PR_HEAD_SHA
ENV GITHUB_PR_HEAD_SHA=$GITHUB_PR_HEAD_SHA

ARG GITHUB_REF_NAME
ENV GITHUB_REF_NAME=$GITHUB_REF_NAME


COPY files/usr /usr

# Setup automatic updates
RUN systemctl enable system-update.timer

# Swap SDDM for GDM
RUN \
  dnf remove -y sddm sddm-wayland-sway && \
  dnf install -y gdm && \
  systemctl enable gdm

# Misc. packages
RUN dnf install -y \
  fish \
  distrobox \
  kubernetes-client \
  grim \
  slurp \
  swappy \
  wf-recorder

# DankMaterial Shell
RUN yes | dnf copr enable avengemedia/dms && \
  dnf install -y dms && \
  systemctl enable /usr/lib/systemd/user/dms.service && \
  dnf remove -y \
  network-manager-applet \
  rofi \
  rofi-themes

# Docker
RUN curl -o "/etc/yum.repos.d/docker.com.linux.fedora.docker-ce.repo" "https://download.docker.com/linux/fedora/docker-ce.repo" && \
  dnf install -y docker-ce docker-ce-cli && \
  systemctl enable docker

# Fingerprint reader setup
RUN authselect enable-feature with-fingerprint && \
  authselect apply-changes

# Fonts
COPY --chmod=744 scripts/google-fonts.sh scripts/nerd-fonts.sh /tmp/
RUN /tmp/google-fonts.sh "Roboto" "Open Sans"
RUN /tmp/nerd-fonts.sh "FiraCode" "Hack" "SourceCodePro" "Terminus" "JetBrainsMono" "NerdFontsSymbolsOnly"

# Enable kanshi service
RUN systemctl --global enable kanshi

# Setup signing
COPY signing/policy.json /usr/etc/containers/
COPY signing/cosign.pub /usr/etc/pki/containers/sediment.pub
COPY signing/registry-config.yaml /usr/etc/containers/registries.d/sediment.yaml

# Set boot entry name
COPY --chmod=700 scripts/set-os-release-pretty-name.sh /tmp/
RUN /tmp/set-os-release-pretty-name.sh

# Finally, validate
RUN ostree container commit
