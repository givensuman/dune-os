FROM ghcr.io/ublue-os/base-main AS dune-os

# Copying system files into main image
COPY system /
COPY scripts /scripts

RUN \
    for script in /scripts/*; do \
        chmod +x "/scripts/$script"; \
    done

RUN  \
    /scripts/packages.sh && \
    /scripts/cosmic.sh && \
    /scripts/ublue.sh && \
    /scripts/flatpaks.sh && \
    /scripts/cleanup.sh && \
    ostree container commit
