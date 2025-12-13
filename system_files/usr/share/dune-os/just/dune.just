# Set up all of Given's dotfiles
dune-dotfiles: dune-install-cli-tools dune-install-fish-plugins dune-setup-configs dune-setup-mise

# Install Given's CLI tools
dune-install-cli-tools:
    #!/usr/bin/env bash
    if [[ ! -f /usr/share/dune-os/dotfiles/brew_packages ]]; then
      echo "Missing brew_package file for reference..."
      exit 1
    fi

    while IFS= read -r package || [[ -n "$package" ]]; do
      # Skip empty lines and comments
      [[ -z "$package" || "$package" =~ ^[[:space:]]*# ]] && continue
      echo "Installing $package..."
      brew install "$package"
    done < /usr/share/dune-os/dotfiles/brew_packages

# Install Given's Fish plugins
dune-install-fish-plugins:
    #!/usr/bin/env bash
    if [[ ! -f /usr/share/dune-os/dotfiles/fish_plugins ]]; then
      echo "Missing fish_plugin file for reference..."
      exit 1
    fi

    while IFS= read -r plugin || [[ -n "$plugin" ]]; do
      # Skip empty lines and comments
      [[ -z "$plugin" || "$plugin" =~ ^[[:space:]]*# ]] && continue
      echo "Installing $plugin..."
      /usr/bin/fish -c "fisher install $plugin"
    done < /usr/share/dune-os/dotfiles/fish_plugins

# Install Given's programming languages
dune-setup-mise:
    #!/usr/bin/env bash
    if [[ ! -f ~/.config/mise/config.toml ]]; then
      echo "Missing config.toml for reference..."
      exit 1
    fi

    (cd ~/.config/mise && mise install);

# Install Given's config files
dune-setup-configs:
    #!/usr/bin/env bash
    if [[ "$(read -e -p 'Are you Given? [y/N]: '; echo $REPLY)" == [Yy]* ]]; then
      for dir in /usr/share/dune-os/dotfiles/*/; do
        [[ ! -d "$dir" ]] && continue
        cp -r "$dir" ~/.config/
      done
    else
      echo "I am about to override a number of configuration directories."
      if [[ "$(read -e -p 'Are you sure I should do this? [y/N]: '; echo $REPLY)" == [Yy]* ]]; then
        for dir in /usr/share/dune-os/dotfiles/*/; do
          [[ ! -d "$dir" ]] && continue
          # Skip these configurations
          dirname=$(basename "$dir")
          [[ dirname == "git" || dirname == "gh" ]] && continue
          cp -r "$dir" ~/.config/
        done
      else
        echo "Fair enough! No changes will be made."
        exit 0
      fi
    fi

# Sync local configs to `dune-os` repository. Intended for use by repository owner.
dune-sync-to-repo-at location:
    #!/usr/bin/env bash
    if [[ ! {{ location }} ]]; then
      echo "Missing argument..."
      echo "Tell me where the `dune-os` repository is."
      exit 1
    fi

    source="/usr/share/dune-os/dotfiles"
    destination="{{ location }}/system_files/usr/share/dune-os/dotfiles"

    echo "Syncing to {{ location }}..."

    # Sync config files
    for dir in "$source/*/"; do
      [[ ! -d "$dir" ]] && continue

      dirname=$(basename "$dir")

      if [[ -d "~/.config/$dirname" ]]; then
        cp -r "~/.config/$dirname" $destination
      else
        echo "Missing ~/.config/$dirname..."
      fi
    done

    # Sync Fish plugins
    if [[ -f ~/.config/fish/fish_plugins ]]; then
      cp ~/.config/fish/fish_plugins $destination
    else
      echo "Missing ~/.config/fish/fish_plugins..."
    fi

    # Sync CLI tools
    brew leaves > "$destination/brew_packages"

# Clean up old packages and Docker/Podman images and volumes
dune-clean:
    #!/usr/bin/env bash
    set -euo pipefail

    echo "Cleaning up system..."
    docker system prune -af
    podman system prune -af
    flatpak uninstall --unused
    rpm-ostree cleanup -bm
    sudo docker system prune -af
    sudo podman system prune -af
