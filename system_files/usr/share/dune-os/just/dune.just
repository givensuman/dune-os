# Clean up old packages and Docker/Podman images and volumes
dune-clean:
    #!/usr/bin/env bash
    set -euox pipefail

    echo "Cleaning up system..."
    docker system prune -af
    podman system prune -af
    flatpak uninstall --unused
    rpm-ostree cleanup -bm
    sudo docker system prune -af
    sudo podman system prune -af

# Forcibly rebuild toolbox container
dune-rebuild-toolbox:
    #!/usr/bin/env bash
    set -euo pipefail

    while true; do
      read -p "This will delete and reinstall your toolbox. Are you sure? (y/N): " choice
      case "$choice" in
          y|Y ) break ;;
          * ) echo "Okey dokey! No changes made." && exit 0 ;;
      esac
    done

    /usr/libexec/toolbox-mount --replace
