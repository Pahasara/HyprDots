#!/bin/bash
# HyprDots installer: installs packages, syncs this repo's dotfiles into $HOME,
# configures GTK/cursors/zsh and enables the user services.
# Run it from the repository root:  ./install.sh

readonly VERSION="3.0"

# ── Colors & logging ─────────────────────────────────────────────────────────
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

log_info()    { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error()   { echo -e "${RED}[ERROR]${NC} $1"; }
log_step()    { echo -e "${BLUE}[STEP]${NC} $1"; }
log_success() { echo -e "${CYAN}[SUCCESS]${NC} $1"; }
log_prompt()  { echo -e "${MAGENTA}[PROMPT]${NC} $1"; }

# confirm "question": returns 0 only when the user answers y/Y
confirm() {
    local answer
    read -rp "$1 (y/n): " answer
    [[ $answer == [yY] ]]
}

# ── Packages ─────────────────────────────────────────────────────────────────
# Core packages (official repos)
PACMAN_PACKAGES=(
    # Session: compositor, bar, notifications, launcher, idle/lock, wallpaper daemon, login manager
    hyprland hypridle hyprlock hyprpicker waybar dunst rofi rofi-calc rofi-emoji awww sddm uwsm
    # Auth agent, keyring, portals (screen sharing, file pickers)
    polkit-kde-agent gnome-keyring xdg-desktop-portal-hyprland xdg-desktop-portal-gtk
    # Audio + Bluetooth
    pipewire pipewire-pulse pipewire-alsa wireplumber gst-plugin-pipewire alsa-utils bluez bluez-utils
    # Theming: GTK (adw-gtk-theme, nwg-look) and Qt (kvantum, qt5ct, qt6ct-kde from AUR)
    qt5-wayland qt6-wayland qt5ct kvantum adw-gtk-theme nwg-look
    # Dolphin helpers: thumbnails and KDE open/mime tools
    kde-cli-tools kdegraphics-thumbnailers ffmpegthumbs
    # Terminal and CLI tools
    kitty zsh starship fzf eza zoxide bat fastfetch lolcat btop ripgrep jq tldr trash-cli tree git wget rsync
    # Archives and downloads
    7zip zip unzip unrar aria2
    # Wayland helpers: clipboard, screenshots, typing (rofi-emoji), brightness, automount
    cliphist grim slurp wtype brightnessctl udiskie
    # Neovim and what its config needs (treesitter parsers, mason LSP servers, waybar window_title.py)
    neovim tree-sitter-cli nodejs npm python
    # Needed by ~/.local/bin/upgrade (rich UI, paccache) and the file manager
    python-rich pacman-contrib yazi
    # Apps
    dolphin gwenview imv mpv yt-dlp mediainfo imagemagick zathura zathura-pdf-mupdf qbittorrent firefox kompare speech-dispatcher
    # Fonts (nerd fonts for the terminal/bar, font-awesome for waybar icons)
    noto-fonts noto-fonts-cjk noto-fonts-emoji
    ttf-cascadia-mono-nerd ttf-jetbrains-mono-nerd ttf-hack-nerd ttf-ubuntu-nerd ttf-dejavu-nerd woff2-font-awesome
    # Firewall helper (~/.local/bin/firewall)
    ufw
)

# Core AUR packages (yay also installs from the official repos, so this list is safe either way)
AUR_PACKAGES=(
    ianny qt6ct-kde apple-fonts waypaper
)

# Optional groups, each asked about separately
DEV_PACKAGES=(dotnet-sdk aspnet-runtime github-cli pnpm)
GAMING_PACKAGES=(steam gamemode mangohud)
GAMING_AUR_PACKAGES=(umu-launcher protonplus faugus-launcher)

# ── Dotfiles ─────────────────────────────────────────────────────────────────
# Config dirs fully owned by this repo: files not in the repo are REMOVED on install,
# so renamed or deleted scripts/modules (old mpv scripts, old hypr lua files) can't linger.
# Everything is backed up first.
MANAGED_CONFIGS=(hypr mpv waybar rofi)

# ── GTK look (edit here, then re-run configure_gtk_themes) ───────────────────
GTK_THEME="adw-gtk3-dark"
ICON_THEME="breeze-dark"
CURSOR_THEME="macOS"
CURSOR_SIZE=28
GTK_FONT="Sans 11"

# ── User services ────────────────────────────────────────────────────────────
ENABLED_USER_UNITS=(
    battery-monitor.service
    headphone-monitor.service
    mic-led-monitor.service
    awww-daemon.service
    udiskie-automount.service
    clipboard-history.service
    hypridle.service
    polkit-authentication.service
    waybar.service
    wayland-env.service
    battery-warning.timer
    wallpaper-rotate.timer
)
OPTIONAL_USER_UNITS=(
    shader-cleaner.service
    steam.service
)

# ── Checks ───────────────────────────────────────────────────────────────────
check_permissions() {
    [[ $EUID -eq 0 ]] && { log_error "Don't run this as root."; exit 1; }
}

check_system() {
    command -v pacman &>/dev/null || { log_error "Not an Arch-based distro."; exit 1; }
    [[ -d .config ]] || { log_error "Run this from the HyprDots repo root (no .config here)."; exit 1; }
    log_info "System check passed."
}

# ── Packages ─────────────────────────────────────────────────────────────────
update_system() {
    log_step "Updating system packages"
    sudo pacman -Syu --noconfirm || log_warning "Update had warnings, continuing..."
}

# install_packages <pacman|yay> <package...>: installs only what is missing
install_packages() {
    local manager=$1; shift
    local pkg to_install=()
    for pkg in "$@"; do
        pacman -Q "$pkg" &>/dev/null || to_install+=("$pkg")
    done
    if [[ ${#to_install[@]} -eq 0 ]]; then
        log_info "Nothing to install, all packages are present."
        return
    fi

    log_info "Installing ${#to_install[@]} package(s): ${to_install[*]}"
    local cmd=(sudo pacman -S --needed --noconfirm)
    [[ $manager == yay ]] && cmd=(yay -S --needed --noconfirm)
    "${cmd[@]}" "${to_install[@]}" || {
        log_error "Some packages failed to install."
        confirm "Continue anyway?" || exit 1
    }
}

install_yay() {
    log_step "Checking for yay"
    command -v yay &>/dev/null && log_info "Yay is installed." && return
    log_info "Installing yay..."
    sudo pacman -S --needed --noconfirm git base-devel
    local tmpdir
    tmpdir=$(mktemp -d)
    git clone https://aur.archlinux.org/yay.git "$tmpdir"
    (cd "$tmpdir" && makepkg -si --noconfirm) || { log_error "Yay install failed."; exit 1; }
    rm -rf "$tmpdir"
    log_success "Yay installed."
}

install_optional_groups() {
    log_step "Optional package groups"

    if confirm "Install dev tools (${DEV_PACKAGES[*]})?"; then
        install_packages pacman "${DEV_PACKAGES[@]}"
    fi

    if confirm "Install gaming stack (${GAMING_PACKAGES[*]} ${GAMING_AUR_PACKAGES[*]})?"; then
        grep -q '^\[multilib\]' /etc/pacman.conf ||
            log_warning "multilib is not enabled in /etc/pacman.conf, Steam needs it."
        install_packages pacman "${GAMING_PACKAGES[@]}"
        install_packages yay "${GAMING_AUR_PACKAGES[@]}"
    fi
}

# ── Dotfiles ─────────────────────────────────────────────────────────────────
backup_configs() {
    local backup_dir
    backup_dir="$HOME/hyprdots_backup_$(date +%Y%m%d_%H%M%S)"
    log_step "Backing up existing configs to $backup_dir"
    mkdir -p "$backup_dir"

    # Back up whatever this repo is about to touch: every top-level .config entry,
    # every script in .local/bin, the shell dotfiles and the GTK files we generate.
    local item
    for item in .config/* .local/bin/* .zshrc .zshenv .zsh_aliases .gtkrc-2.0 .config/gtk-3.0 .config/gtk-4.0; do
        [[ -e "$HOME/$item" ]] || continue
        mkdir -p "$backup_dir/$(dirname "$item")"
        cp -a "$HOME/$item" "$backup_dir/$item" && log_info "Backed up $item"
    done
    log_success "Backup complete at $backup_dir"
}

install_dotfiles() {
    log_step "Installing HyprDots configs"
    mkdir -p "$HOME/.config" "$HOME/.local/bin" "$HOME/.local/share" "$HOME/Pictures/Wallpapers"

    # .config: one rsync per app dir; managed dirs also drop files the repo no longer has
    local dir name flags
    for dir in .config/*/; do
        name=$(basename "$dir")
        flags=(-a)
        [[ " ${MANAGED_CONFIGS[*]} " == *" $name "* ]] && flags+=(--delete)
        mkdir -p "$HOME/.config/$name"
        rsync "${flags[@]}" "$dir" "$HOME/.config/$name/" &&
            log_info "Synced .config/$name${flags[1]:+ (stale files removed)}" ||
            log_warning "Failed to sync .config/$name"
    done
    find .config -maxdepth 1 -type f -exec cp {} "$HOME/.config/" \;   # loose files in .config

    [[ -d .local ]] && rsync -a .local/ "$HOME/.local/" && log_info "Synced .local"
    [[ -d .walls ]] && rsync -a .walls/ "$HOME/Pictures/Wallpapers/" && log_info "Synced wallpapers"

    # Shell dotfiles
    local file
    for file in .zshrc .zshenv .zsh_aliases; do
        [[ -f $file ]] && cp "$file" "$HOME/$file" || log_warning "Could not copy $file"
    done

    # Scripts must be executable
    find "$HOME/.local/bin" -type f -exec chmod +x {} \; 2>/dev/null

    log_success "Config files installed."
}

# ── Shell ────────────────────────────────────────────────────────────────────
install_zinit() {
    log_step "Setting up Zsh + Zinit"
    command -v zsh &>/dev/null || { log_error "Zsh not installed."; exit 1; }

    local ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

    if [[ ! -d "$ZINIT_HOME" ]]; then
        log_info "Installing Zinit..."
        mkdir -p "$(dirname "$ZINIT_HOME")"
        git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME" || { log_error "Zinit install failed."; exit 1; }
    fi
    # Zinit installs the plugins itself the first time zsh starts with the new .zshrc
    log_info "Zinit manager ready. Plugins install on first zsh start."

    if [[ "$SHELL" != *"zsh"* ]]; then
        log_info "Changing default shell to zsh..."
        chsh -s "$(command -v zsh)" || log_warning "Failed to set zsh as default shell"
    fi

    log_success "Zsh and Zinit configured."
}

# ── Look & feel ──────────────────────────────────────────────────────────────
configure_gtk_themes() {
    log_step "Configuring GTK ($GTK_THEME, icons: $ICON_THEME, cursor: $CURSOR_THEME)"

    if command -v gsettings &>/dev/null; then
        gsettings set org.gnome.desktop.interface gtk-theme "$GTK_THEME" 2>/dev/null || log_warning "Could not set GTK theme via gsettings"
        gsettings set org.gnome.desktop.interface icon-theme "$ICON_THEME" 2>/dev/null || log_warning "Could not set icon theme via gsettings"
        gsettings set org.gnome.desktop.interface cursor-theme "$CURSOR_THEME" 2>/dev/null || log_warning "Could not set cursor theme via gsettings"
        gsettings set org.gnome.desktop.interface color-scheme "prefer-dark" 2>/dev/null   # dark libadwaita/GTK4 apps
    fi

    # GTK 3 and 4 share the same core settings
    local core_settings="gtk-theme-name=$GTK_THEME
gtk-icon-theme-name=$ICON_THEME
gtk-font-name=$GTK_FONT
gtk-cursor-theme-name=$CURSOR_THEME
gtk-cursor-theme-size=$CURSOR_SIZE
gtk-application-prefer-dark-theme=1"

    mkdir -p "$HOME/.config/gtk-3.0" "$HOME/.config/gtk-4.0"

    cat > "$HOME/.config/gtk-3.0/settings.ini" << EOF
[Settings]
$core_settings
gtk-toolbar-style=GTK_TOOLBAR_BOTH
gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
gtk-button-images=0
gtk-menu-images=0
gtk-enable-event-sounds=1
gtk-enable-input-feedback-sounds=0
gtk-xft-antialias=1
gtk-xft-hinting=1
gtk-xft-hintstyle=hintslight
gtk-xft-rgba=rgb
gtk-decoration-layout=appmenu:none
EOF

    cat > "$HOME/.config/gtk-4.0/settings.ini" << EOF
[Settings]
$core_settings
EOF

    # GTK 2 needs quoted strings
    cat > "$HOME/.gtkrc-2.0" << EOF
gtk-theme-name="$GTK_THEME"
gtk-icon-theme-name="$ICON_THEME"
gtk-font-name="$GTK_FONT"
gtk-cursor-theme-name="$CURSOR_THEME"
gtk-cursor-theme-size=$CURSOR_SIZE
gtk-toolbar-style=GTK_TOOLBAR_BOTH
gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
gtk-button-images=0
gtk-menu-images=0
gtk-enable-event-sounds=1
gtk-enable-input-feedback-sounds=0
gtk-xft-antialias=1
gtk-xft-hinting=1
gtk-xft-hintstyle="hintslight"
gtk-xft-rgba="rgb"
EOF

    log_success "GTK configured."
}

install_cursors() {
    log_step "Installing macOS cursor themes (Hyprcursor + XCursor)"
    local icons="$HOME/.local/share/icons"
    local base="https://github.com/Pahasara/apple_hyprcursor/releases/latest/download"
    mkdir -p "$icons"

    # install_cursor <label> <installed dir name> <archive name>: skips the download if already present
    install_cursor() {
        local label=$1 dirname=$2 archive=$3
        if [[ -d "$icons/$dirname" ]]; then
            log_info "$label already installed, skipping download."
            return
        fi
        log_info "Downloading $label..."
        curl -L --fail --retry 3 --output "$icons/$archive" "$base/$archive" || { log_error "Failed to download $label."; exit 1; }
        tar -xf "$icons/$archive" -C "$icons" && rm "$icons/$archive" && log_info "Installed $label"
    }

    install_cursor "Hyprcursor" "macOS-hyprcursor" "macOS-hyprcursor.tar.xz"
    install_cursor "XCursor" "macOS" "macOS.tar.xz"

    log_success "Cursor themes installation complete."
}

# ── Services ─────────────────────────────────────────────────────────────────
configure_user_services() {
    log_step "Configuring user services"

    # Pick up the unit files we just copied before checking or enabling anything
    systemctl --user daemon-reload

    log_prompt "Enabled by default:"
    printf '  - %s\n' "${ENABLED_USER_UNITS[@]}"
    log_prompt "Available but NOT enabled by default:"
    printf '  - %s\n' "${OPTIONAL_USER_UNITS[@]}"
    echo

    if confirm "Enable the default units now?"; then
        local unit
        for unit in "${ENABLED_USER_UNITS[@]}"; do
            if ! systemctl --user cat "$unit" &>/dev/null; then
                log_warning "Unit not found, skipped: $unit"
                continue
            fi
            systemctl --user enable "$unit" &>/dev/null && log_info "Enabled $unit" || log_warning "Could not enable $unit"
        done
    else
        log_info "Enable them later with: systemctl --user enable <unit>"
    fi

    log_success "User services configured."
}

configure_services() {
    log_step "Enabling system services"

    systemctl --user enable --now pipewire.service pipewire-pulse.service wireplumber.service 2>/dev/null

    sudo systemctl enable sddm.service

    if pacman -Q bluez bluez-utils &>/dev/null; then
        sudo systemctl enable bluetooth.service
        log_info "Bluetooth service enabled"
    fi

    log_success "System services configured."
}

final_setup() {
    log_step "Performing final setup tasks"
    fc-cache -f &>/dev/null
    gtk-update-icon-cache -f -t "$HOME/.local/share/icons" 2>/dev/null || true
    log_success "Final setup completed."
}

# ── Main ─────────────────────────────────────────────────────────────────────
main() {
    clear
    echo -e "${GREEN}"
    cat << "EOF"
                                                          shinzo™
 _     _ __   __  _____   ______ ______   _____  _______ _______
 |_____|   \_/   |_____] |_____/ |     \ |     |    |    |______
 |     |    |    |       |    \_ |_____/ |_____|    |    ______|

EOF
    echo -e "${NC}${CYAN}HyprDots Installation Script v${VERSION}${NC}"
    echo -e "This will install and configure your Hyprland compositor with smart configurations."
    echo

    check_permissions
    check_system

    confirm "Start installation?" || exit 0

    update_system
    backup_configs
    install_packages pacman "${PACMAN_PACKAGES[@]}"
    install_yay
    install_packages yay "${AUR_PACKAGES[@]}"
    install_optional_groups
    install_dotfiles
    configure_gtk_themes
    install_cursors
    install_zinit
    configure_user_services
    configure_services
    final_setup

    echo
    log_success "HyprDots installation complete!"
    log_info "Changes made:"
    log_info "  ✓ Installed all packages"
    log_info "  ✓ Synced configs (old files in managed dirs removed, backup kept)"
    log_info "  ✓ Configured GTK theme and cursors"
    log_info "  ✓ Set up user services"
    log_info "  ✓ Updated font and icon caches"
    echo
    log_warning "Please reboot to apply all changes and start the desktop environment."
    log_info "After reboot, you may need to select 'Hyprland (uwsm)' from your display manager."

    confirm "Reboot now?" && sudo reboot
}

# Only run when executed, not when sourced (lets the functions be tested)
[[ "${BASH_SOURCE[0]}" == "$0" ]] && main "$@"
