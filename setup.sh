#!/usr/bin/env bash

set -e

DOTFILES_DIR="$HOME/dotfiles"
TARGET_CONFIG="$HOME/.config"
TARGET_SERVICES="$HOME/.config/systemd/user"
TARGET_BIN="$HOME/.local/bin"

link_dir_contents() {
    local src_dir="$1"
    local dst_dir="$2"

    mkdir -p "$dst_dir"

    for item in "$src_dir"/*; do
        local base_item
        base_item=$(basename "$item")
        local target_item="$dst_dir/$base_item"

        if [ -e "$target_item" ] || [ -L "$target_item" ]; then
            echo "Removing $target_item"
            rm -rf "$target_item"
        fi

        echo "Linking $base_item → $target_item"
        ln -sr "$item" "$target_item"
    done
}

run_services() {
    echo "Linking services..."
    link_dir_contents "$DOTFILES_DIR/services" "$TARGET_SERVICES"
    echo "Reloading systemd..."
    systemctl --user daemon-reload

    shopt -s nullglob
    local service_files=("$TARGET_SERVICES"/*.service)
    if ((${#service_files[@]})); then
        for svc in "${service_files[@]}"; do
            svc_name=$(basename "$svc")
            echo "Enabling $svc_name"
            systemctl --user enable --now "$svc_name" || true
        done
    else
        echo "No services to enable."
    fi
    shopt -u nullglob
}

run_config() {
    echo "Linking config..."
    link_dir_contents "$DOTFILES_DIR/.config" "$TARGET_CONFIG"
}

install_bin() {
    local url="$1"
    local inner_path="$2"
    local final_name="$3"

    local bin_path="$DOTFILES_DIR/bin/$final_name"
    local link_path="$TARGET_BIN/$final_name"

    if [ -e "$link_path" ] || [ -L "$link_path" ]; then
        echo "$final_name already installed and linked, skipping."
        return
    fi

    if [ -f "$bin_path" ]; then
        echo "Linking existing $final_name..."
        mkdir -p "$TARGET_BIN"
        ln -sr "$bin_path" "$link_path"
        return
    fi

    local tmp_dir="$DOTFILES_DIR/tmp_bin"
    local archive="$tmp_dir/archive"
    local extract_dir="$tmp_dir/extracted"

    mkdir -p "$DOTFILES_DIR/bin" "$tmp_dir" "$extract_dir"

    echo "Downloading $final_name..."
    wget -q "$url" -O "$archive"

    case "$url" in
        *.tar.xz) tar -xf "$archive" -C "$extract_dir" ;;
        *.tar.gz) tar -xzf "$archive" -C "$extract_dir" ;;
        *.zip)    unzip -q "$archive" -d "$extract_dir" ;;
        *)        mv "$archive" "$bin_path"
                  chmod +x "$bin_path"
                  rm -rf "$tmp_dir"
                  mkdir -p "$TARGET_BIN"
                  ln -sr "$bin_path" "$link_path"
                  echo "Installed and linked $final_name"
                  return ;;
    esac

    mv "$extract_dir/$inner_path" "$bin_path"
    chmod +x "$bin_path"
    rm -rf "$tmp_dir"

    mkdir -p "$TARGET_BIN"
    ln -sr "$bin_path" "$link_path"

    echo "Installed and linked $final_name"
}

run_bin() {
    echo "Installing and linking custom binaries..."
    install_bin "https://www.7-zip.org/a/7z2501-linux-arm64.tar.xz" "7zz" "7z"
}

full_setup() {
    run_config
    run_services
    run_bin
}

setup_ssh_config() {
    local ssh_dir="$HOME/.ssh"
    local ssh_config="$ssh_dir/config"

    mkdir -p "$ssh_dir"
    chmod 700 "$ssh_dir"

    if [ ! -f "$ssh_config" ]; then
        echo "Creating ~/.ssh/config with GitHub settings..."
        cat > "$ssh_config" <<'EOF'
Host github.com
    User git
    Hostname github.com
    PreferredAuthentications publickey
    IdentityFile ~/.ssh/github
EOF
        chmod 600 "$ssh_config"
    else
        echo "~/.ssh/config already exists, skipping."
    fi
}

first_setup() {
    sudo dnf update -y --refresh
    sudo dnf copr enable solopasha/hyprland -y
    sudo dnf install -y \
        https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
        https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

    sudo dnf install -y firefox foot hyprland hyprpaper hyprpolkitagent mako qt5-qtwayland \
        qt6-qtwayland uwsm wofi xdg-desktop-portal-gtk xdg-desktop-portal-hyprland \
        dnf-plugins-core sddm neovim waybar fcitx5 ffmpeg mpv btop

    sudo dnf remove kitty -y

    sudo dnf config-manager addrepo --from-repofile=https://download.docker.com/linux/fedora/docker-ce.repo -y
    sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
    sudo groupadd docker || true
    sudo usermod -aG docker "$USER"

    full_setup
    setup_ssh_config
}

DO_SERVICES=false
DO_CONFIG=false
DO_BIN=false
FIRST=false
RUN_FULL=false

if [ $# -eq 0 ]; then
    RUN_FULL=true
fi

while [ $# -gt 0 ]; do
    case "$1" in
        --services) DO_SERVICES=true ;;
        --config)   DO_CONFIG=true ;;
        --bin)      DO_BIN=true ;;
        --first)    FIRST=true ;;
        --all)      RUN_FULL=true ;;
        *) echo "Unknown flag: $1" && exit 1 ;;
    esac
    shift
done

if [ "$RUN_FULL" = true ]; then
    full_setup
else
    [ "$DO_CONFIG" = true ] && run_config
    [ "$DO_SERVICES" = true ] && run_services
    [ "$DO_BIN" = true ] && run_bin
    [ "$FIRST" = true ] && first_setup
fi
