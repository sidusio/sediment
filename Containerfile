ARG OS_VERSION=40

FROM ghcr.io/ublue-os/sericea-main:$OS_VERSION

ARG OS_VERSION
ENV OS_VERSION $OS_VERSION

COPY config/files/usr /usr

# Swap SDDM for GDM
RUN \
    rpm-ostree override remove \
      sddm \
      sddm-wayland-sway && \
    rpm-ostree install \
      gdm && \
    systemctl enable \
      gdm

# Misc. packages
RUN rpm-ostree install \
    fish \
    kubernetes-client \
    grim \
    slurp \
    swappy \
    wf-recorder

# Docker
RUN curl -o "/etc/yum.repos.d/docker.com.linux.fedora.docker-ce.repo" \
      "https://download.docker.com/linux/fedora/docker-ce.repo" && \
    rpm-ostree install \
      docker-ce \
      docker-ce-cli && \
    systemctl enable \
      docker

# Fingerprint reader setup
RUN authselect enable-feature with-fingerprint && \
    authselect apply-changes

# Install ublue-update
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/blue-build/modules/7ad6f3b1a766508085525cd979430de2639db652/modules/bling/installers/ublue-update.sh)"

# Fonts
COPY --chmod=744 \
    config/scripts/google-fonts.sh \
    config/scripts/nerd-fonts.sh \
    /tmp/
RUN /tmp/google-fonts.sh \
    "Roboto" \
    "Open Sans"
RUN /tmp/nerd-fonts.sh \
    "FiraCode" \
    "Hack" \
    "SourceCodePro" \
    "Terminus" \
    "JetBrainsMono" \
    "NerdFontsSymbolsOnly"

# Setup signing
COPY signing/policy.json /usr/etc/containers/
COPY signing/cosign.pub /usr/etc/pki/containers/sediment.pub
COPY signing/registry-config.yaml /usr/etc/containers/registries.d/sediment.yaml


# Finally, validate
RUN ostree container commit