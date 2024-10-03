ARG OS_VERSION=40

FROM ghcr.io/ublue-os/sericea-main:$OS_VERSION

ARG OS_VERSION
ENV OS_VERSION=$OS_VERSION

ARG GITHUB_SHA
ENV GITHUB_SHA=$GITHUB_SHA

ARG GITHUB_PR_HEAD_SHA
ENV GITHUB_PR_HEAD_SHA=$GITHUB_PR_HEAD_SHA

ARG GITHUB_REF_NAME
ENV GITHUB_REF_NAME=$GITHUB_REF_NAME


COPY files/usr /usr

# Swap SDDM for GDM
RUN \
  rpm-ostree override remove sddm sddm-wayland-sway && \
  rpm-ostree install gdm && \
  systemctl enable gdm

# Misc. packages
RUN rpm-ostree install \
  fish \
  kubernetes-client \
  grim \
  slurp \
  swappy \
  wf-recorder

# Docker
RUN curl -o "/etc/yum.repos.d/docker.com.linux.fedora.docker-ce.repo" "https://download.docker.com/linux/fedora/docker-ce.repo" && \
  rpm-ostree install docker-ce docker-ce-cli && \
  systemctl enable docker

# DisplayLink driver
RUN curl -o "/etc/yum.repos.d/displaylink.repo" "https://copr.fedorainfracloud.org/coprs/crashdummy/Displaylink/repo/fedora-${OS_VERSION}/crashdummy-Displaylink-fedora-${OS_VERSION}.repo" && \
  rpm-ostree install displaylink && \
  systemctl enable displaylink-driver

# Fingerprint reader setup
RUN authselect enable-feature with-fingerprint && \
  authselect apply-changes

# Install ublue-update
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/blue-build/modules/7ad6f3b1a766508085525cd979430de2639db652/modules/bling/installers/ublue-update.sh)"

# Fonts
COPY --chmod=744 scripts/google-fonts.sh scripts/nerd-fonts.sh /tmp/
RUN /tmp/google-fonts.sh "Roboto" "Open Sans"
RUN /tmp/nerd-fonts.sh "FiraCode" "Hack" "SourceCodePro" "Terminus" "JetBrainsMono" "NerdFontsSymbolsOnly"

# Setup signing
COPY signing/policy.json /usr/etc/containers/
COPY signing/cosign.pub /usr/etc/pki/containers/sediment.pub
COPY signing/registry-config.yaml /usr/etc/containers/registries.d/sediment.yaml

# Set boot entry name
COPY --chmod=700 scripts/set-os-release-pretty-name.sh /tmp/
RUN /tmp/set-os-release-pretty-name.sh

# Finally, validate
RUN ostree container commit
