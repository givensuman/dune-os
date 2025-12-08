FROM scratch AS ctx

COPY /build_scripts /build_scripts

FROM ghcr.io/ublue-os/base-main AS dune-os

COPY /system_files /

# Build, cleanup, lint.
RUN --mount=type=cache,dst=/var/cache/libdnf5 \
    --mount=type=cache,dst=/var/cache/rpm-ostree \
    --mount=type=bind,from=ctx,source=/,target=/ctx \
    for script in /ctx/build_scripts/*.sh; do \
      bash "$script"; \
    done

RUN bootc container lint && \
ostree container commit
