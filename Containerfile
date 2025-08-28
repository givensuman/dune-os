FROM ghcr.io/ublue-os/base-main AS dune-os

# Copying system files into main image
COPY system /
COPY scripts /scripts

RUN chmod +x /scripts/*

RUN  \
  # /scripts/packages.sh && \
  # /scripts/cosmic.sh && \
  # /scripts/ublue.sh && \
  # /scripts/flatpaks.sh && \
  ostree container commit

COPY override /

RUN \
  /scripts/cleanup.sh && \
  ostree container commit
