FROM ghcr.io/ublue-os/base-main AS dune-os

LABEL org.opencontainers.image.source=https://github.com/givensuman/dune-os
LABEL org.opencontainers.image.description="custom atomic linux build"
LABEL org.opencontainers.image.licenses="Apache-2.0"


# Copying system files into main image
COPY system /
COPY scripts /scripts

RUN chmod +x /scripts/*

RUN  \
  for script in /scripts/*.sh; do \
  bash "$script"; \
  if [ $? -ne 0 ]; then \
  echo "Error executing $script" >&2; \
  exit 1; \
  fi; \
  done && \
  ostree container commit
