# ARG BASE_IMAGE_NAME="${BASE_IMAGE_NAME:-base-main}"
# ARG IMAGE_TAG="${IMAGE_TAG:-stable}"

FROM ghcr.io/ublue-os/base-main AS dune-os

# Copying system files into main image
COPY system /
COPY scripts /scripts

RUN \
    for script in $(ls /scripts); do \
        chmod +x $script; \
    done

RUN setenforce 0

RUN /scripts/packages.sh && \
    /scripts/cosmic.sh && \
    /scripts/homebrew&& \
    /scripts/flatpaks.sh && \
    /scripts/services && \
    /scripts/fonts && \
    /scripts/cleanup.sh && \
    ostree container commit
