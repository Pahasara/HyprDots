#!/bin/bash

# Color definitions
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

# Logging functions
log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }
log_step() { echo -e "${BLUE}[STEP]${NC} $1"; }
log_success() { echo -e "${CYAN}[SUCCESS]${NC} $1"; }
log_prompt() { echo -e "${MAGENTA}[PROMPT]${NC} $1"; }

# Package lists
PACMAN_PACKAGES=(
    "hyprland" "waybar" "dunst" "hypridle" "hyprlock"
    "sddm" "polkit-gnome" "xdg-desktop-portal-hyprland"
    "xdg-desktop-portal-gtk" "pipewire" "pipewire-pulse" "pipewire-alsa"
    "qt5-wayland" "qt6-wayland" "wireplumber" "uwsm"
    "kitty" "zsh" "starship" "fzf" "eza" "fastfetch" "lolcat"
    "7zip" "aria2" "cliphist" "grim" "slurp" "brightnessctl"
    "udiskie" "unzip" "mediainfo" "kompare"
    "kde-cli-tools" "kdegraphics-thumbnailers" "qt5ct"
    "ripgrep" "kvantum" "bluez" "bluez-utils"
    "mpv" "ffmpegthumbs" "imagemagick" "imv" "speech-dispatcher"
    "noto-fonts" "noto-fonts-cjk" "noto-fonts-emoji"
    "ttf-cascadia-mono-nerd" "ttf-jetbrains-mono-nerd" "ttf-hack-nerd"
    "ttf-ubuntu-nerd" "ttf-dejavu-nerd" "woff2-font-awesome"
    "dolphin" "qbittorrent" "zathura" "zathura-cb" "zathura-pdf-mupdf"
    "neovim" "swww" "yazi" "zoxide"
)

AUR_PACKAGES=(
    "ianny" "qt6ct-kde" "rofi-calc-git" "rofi-emoji-git"
    "apple-fonts" "nomacs" "zen-browser-bin" "waypaper"
    "kvantum-theme-whitesur-git"
    "whitesur-gtk-theme"
    "whitesur-icon-theme"
)

# User services that are enabled by default
ENABLED_USER_SERVICES=(
    "battery-monitor.service"
    "headphone-monitor.service"
    "mic-led-monitor.service"
    "swww-daemon.service"
    "udiskie-automount.service"
)

ENABLED_GRAPHICAL_SERVICES=(
    "clipboard-history.service"
    "hypridle.service"
    "polkit-authentication.service"
    "waybar.service"
    "wayland-env.service"
)

ENABLED_TIMERS=(
    "battery-warning.timer"
    "wallpaper-rotate.timer"
)

check_permissions() {
    [[ $EUID -eq 0 ]] && { log_error "Don't run this as root."; exit 1; }
}

check_system() {
    command -v pacman &>/dev/null || { log_error "Not an Arch-based distro."; exit 1; }
    log_info "System check passed."
}

update_system() {
    log_step "Updating system packages"
    sudo pacman -Syu --noconfirm || log_warning "Update had warnings, continuing..."
}

backup_configs() {
    local backup_dir="$HOME/hyprdots_backup_$(date +%Y%m%d_%H%M%S)"
    log_step "Backing up configs to $backup_dir"
    mkdir -p "$backup_dir"
    local items=(
        ".config/hypr" ".config/waybar" ".config/dunst" ".config/rofi"
        ".config/kitty" ".config/yazi" ".config/neovim" ".config/mpv"
        ".config/gtk-3.0" ".config/gtk-4.0" ".config/qt5ct" ".config/qt6ct"
        ".config/Kvantum" ".config/systemd"
        ".zshrc" ".zshenv" ".gtkrc-2.0"
    )
    for item in "${items[@]}"; do
        [[ -e "$HOME/$item" ]] && cp -r "$HOME/$item" "$backup_dir/$item" && log_info "Backed up $item"
    done
    log_success "Backup complete at $backup_dir"
}

install_pacman_packages() {
    log_step "Installing official repo packages"
    local to_install=()
    for pkg in "${PACMAN_PACKAGES[@]}"; do
        pacman -Q "$pkg" &>/dev/null || to_install+=("$pkg")
    done
    [[ ${#to_install[@]} -eq 0 ]] && log_info "All packages already installed." && return
    sudo pacman -S --needed --noconfirm "${to_install[@]}" || {
        log_error "Failed to install some packages."
        read -p "Continue anyway? (y/n): " c && [[ $c != [yY] ]] && exit 1
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

install_aur_packages() {
    log_step "Installing AUR packages"
    local to_install=()
    for pkg in "${AUR_PACKAGES[@]}"; do
        yay -Q "$pkg" &>/dev/null || to_install+=("$pkg")
    \
    done
    [[ ${#to_install[@]} -eq 0 ]] && log_info "All AUR packages installed." && return
    yay -S --needed --noconfirm "${to_install[@]}" || {
        log_warning "Some AUR packages may have failed."
        read -p "Continue anyway? (y/n): " c && [[ $c != [yY] ]] && exit 1
    }
}

install_dotfiles() {
    log_step "Installing HyprDots configs"
    mkdir -p "$HOME/.config" "$HOME/.local/bin" "$HOME/.local/share" "$HOME/Pictures/Wallpapers"

    # Copy config files
    [[ -d ".config" ]] && cp -r .config/* "$HOME/.config/" && log_info "Copied .config files"
    [[ -d ".local" ]] && cp -r .local/* "$HOME/.local/" && log_info "Copied .local files"
    [[ -d ".walls" ]] && cp -r .walls/* "$HOME/Pictures/Wallpapers/" 2>/dev/null && log_info "Copied wallpapers"
    
    # Copy zsh files
    [[ -f ".zshrc" ]] && cp .zshrc "$HOME/.zshrc" || log_warning "Could not copy .zshrc"
    [[ -f ".zshenv" ]] && cp .zshenv "$HOME/.zshenv" || log_warning "Could not copy .zshenv"
    [[ -f ".zsh_aliases" ]] && cp .zsh_aliases "$HOME/.zsh_aliases" || log_warning "Could not copy .zsh_aliases"
    
    # Ensure proper permissions for executables
    find "$HOME/.local/bin" -type f -exec chmod +x {} \; 2>/dev/null

    log_success "Config files installed."
}

install_zinit() {
    log_step "Setting up Zsh + Zinit"
    command -v zsh &>/dev/null || { log_error "Zsh not installed."; exit 1; }
    
    local ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
    
    # Check for existing OMZ (and remove it if found for a clean start)
    # if [[ -d "$HOME/.oh-my-zsh" ]]; then
    #     log_warning "Found Oh My Zsh installation. Removing it for Zinit migration."
    #     rm -rf "$HOME/.oh-my-zsh"
    # fi

    # Install Zinit if not present
    if [[ ! -d "$ZINIT_HOME" ]]; then
        log_info "Installing Zinit..."
        mkdir -p "$(dirname "$ZINIT_HOME")"
        git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME" || { log_error "Zinit install failed."; exit 1; }
    fi
    
    # Zinit handles plugin installation when zshrc is sourced, we only need to install the base manager.
    log_info "Zinit manager installed. Plugins will be installed when Zsh is first run."

    # Change default shell
    if [[ "$SHELL" != *"zsh"* ]]; then
        log_info "Changing default shell to zsh..."
        chsh -s "$(which zsh)" || log_warning "Failed to set zsh as default shell"
    fi
    
    log_success "Zsh and Zinit configured."
}


configure_gtk_themes() {
    log_step "Configuring GTK themes"
    
    # Wait for AUR packages to be properly installed
    sleep 2
    
    # Set GTK theme via gsettings
    if command -v gsettings &>/dev/null; then
        gsettings set org.gnome.desktop.interface gtk-theme "WhiteSur-Dark" 2>/dev/null || log_warning "Could not set GTK theme via gsettings"
        gsettings set org.gnome.desktop.interface icon-theme "WhiteSur-dark" 2>/dev/null || log_warning "Could not set icon theme via gsettings"
        gsettings set org.gnome.desktop.interface cursor-theme "macOS" 2>/dev/null || log_warning "Could not set cursor theme via gsettings"
    fi
    
    # Create GTK-3.0 config
    mkdir -p "$HOME/.config/gtk-3.0"
    cat > "$HOME/.config/gtk-3.0/settings.ini" << EOF
[Settings]
gtk-theme-name=WhiteSur-Dark
gtk-icon-theme-name=WhiteSur-dark
gtk-font-name=Sans 11
gtk-cursor-theme-name=macOS
gtk-cursor-theme-size=28
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
gtk-application-prefer-dark-theme=1
gtk-decoration-layout=appmenu:none
EOF

    # Create GTK-4.0 config
    mkdir -p "$HOME/.config/gtk-4.0"

    # Check if WhiteSur theme symlinks exist and preserve them
    local gtk4_theme_dir="/usr/share/themes/WhiteSur-Dark/gtk-4.0"
    if [[ -d "$gtk4_theme_dir" ]]; then
        # Create symlinks if they don't exist
        [[ ! -L "$HOME/.config/gtk-4.0/gtk.css" ]] && ln -sf "$gtk4_theme_dir/gtk.css" "$HOME/.config/gtk-4.0/gtk.css"
        [[ ! -L "$HOME/.config/gtk-4.0/gtk-dark.css" ]] && ln -sf "$gtk4_theme_dir/gtk-dark.css" "$HOME/.config/gtk-4.0/gtk-dark.css"
        log_info "GTK-4.0 theme symlinks preserved/created"
    fi

    cat > "$HOME/.config/gtk-4.0/settings.ini" << EOF
[Settings]
gtk-theme-name=WhiteSur-Dark
gtk-icon-theme-name=WhiteSur-dark
gtk-font-name=Sans 11
gtk-cursor-theme-name=macOS
gtk-cursor-theme-size=28
gtk-application-prefer-dark-theme=1
EOF

    # Create GTK-2.0 config
    cat > "$HOME/.gtkrc-2.0" << EOF
gtk-theme-name="WhiteSur-Dark"
gtk-icon-theme-name="WhiteSur-dark"
gtk-font-name="Sans 11"
gtk-cursor-theme-name="macOS"
gtk-cursor-theme-size=28
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

    log_success "GTK themes configured."
}

install_cursors() {
    log_step "Installing macOS cursor themes (Hyprcursor + XCursor)"
    mkdir -p "$HOME/.local/share/icons"

    local HCUR_URL="https://github.com/Pahasara/apple_hyprcursor/releases/latest/download/macOS-hyprcursor.tar.xz"
    local XCUR_URL="https://github.com/Pahasara/apple_hyprcursor/releases/latest/download/macOS.tar.xz"

    local HCUR_FILE="$HOME/.local/share/icons/macOS-hyprcursor.tar.xz"
    local XCUR_FILE="$HOME/.local/share/icons/macOS.tar.xz"

    log_info "Downloading Hyprcursor..."
    curl -L --fail --output "$HCUR_FILE" "$HCUR_URL" || { log_error "Failed to download Hyprcursor."; exit 1; }

    log_info "Downloading XCursor..."
    curl -L --fail --output "$XCUR_FILE" "$XCUR_URL" || { log_error "Failed to download XCursor."; exit 1; }

    log_info "Extracting cursors..."
    tar -xf "$HCUR_FILE" -C "$HOME/.local/share/icons" && rm "$HCUR_FILE" && log_info "Installed macOS Hyprcursor"
    tar -xf "$XCUR_FILE" -C "$HOME/.local/share/icons" && rm "$XCUR_FILE" && log_info "Installed macOS XCursor"

    log_success "Cursor themes installation complete."
}

configure_user_services() {
    log_step "Configuring user services"
    
    # Create systemd user directories
    mkdir -p "$HOME/.config/systemd/user/default.target.wants"
    mkdir -p "$HOME/.config/systemd/user/graphical-session.target.wants"
    mkdir -p "$HOME/.config/systemd/user/timers.target.wants"
    
    log_prompt "The following user services are available:"
    echo "  - battery-monitor.service (battery monitoring)"
    echo "  - headphone-monitor.service (headphone plugging detection)"
    echo "  - mic-led-monitor.service (microphone LED indicator)"
    echo "  - swww-daemon.service (wallpaper daemon)"
    echo "  - udiskie-automount.service (auto-mounting)"
    echo "  - clipboard-history.service (clipboard management)"
    echo "  - polkit-authentication.service (authentication agent)"
    echo "  - wayland-env.service (environment variables)"
    echo "  - battery-warning.timer (battery warning timer)"
    echo "  - wallpaper-rotate.timer (wallpaper rotate timer)"
    echo "  - shader-cleaner.service (not enabled by default)"
    echo
    
    read -p "Enable default services automatically? (y/n): " auto_enable
    
    if [[ $auto_enable == [yY] ]]; then
        # Enable default.target services
        for service in "${ENABLED_USER_SERVICES[@]}"; do
            if [[ -f "$HOME/.config/systemd/user/$service" ]]; then
                systemctl --user enable "$service" 2>/dev/null && log_info "Enabled $service"
            fi
        done
        
        # Enable graphical-session.target services
        for service in "${ENABLED_GRAPHICAL_SERVICES[@]}"; do
            if [[ -f "$HOME/.config/systemd/user/$service" ]] || [[ -f "/usr/lib/systemd/user/$service" ]]; then
                systemctl --user enable "$service" 2>/dev/null && log_info "Enabled $service for graphical session"
            fi
        done
        
        # Enable timers
        for timer in "${ENABLED_TIMERS[@]}"; do
            if [[ -f "$HOME/.config/systemd/user/$timer" ]]; then
                systemctl --user enable "$timer" 2>/dev/null && log_info "Enabled $timer"
            fi
        done
    else
        log_info "You can manually enable services later using:"
        log_info "systemctl --user enable <service-name>"
    fi
    
    # Reload systemd user daemon
    systemctl --user daemon-reload
    
    log_success "User services configured."
}

configure_services() {
    log_step "Enabling system services"
    
    # Enable pipewire services
    systemctl --user enable --now pipewire.service pipewire-pulse.service wireplumber.service 2>/dev/null
    
    # Enable SDDM
    sudo systemctl enable sddm.service
    
    # Enable Bluetooth if packages are installed
    if pacman -Q bluez bluez-utils &>/dev/null; then
        sudo systemctl enable bluetooth.service
        log_info "Bluetooth service enabled"
    fi
    
    log_success "System services configured."
}

final_setup() {
    log_step "Performing final setup tasks"
    
    # Update font cache
    fc-cache -fv &>/dev/null
    
    # Update GTK icon cache
    gtk-update-icon-cache -f -t "$HOME/.local/share/icons" 2>/dev/null || true
    
    # Set executable permissions for scripts
    find "$HOME/.config/hypr/scripts" -type f -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true
    find "$HOME/.local/bin" -type f -exec chmod +x {} \; 2>/dev/null || true
    
    log_success "Final setup completed."
}

main() {
    clear
    echo -e "${GREEN}"
    cat << "EOF"
                                                          shinzo™
 _     _ __   __  _____   ______ ______   _____  _______ _______
 |_____|   \_/   |_____] |_____/ |     \ |     |    |    |______
 |     |    |    |       |    \_ |_____/ |_____|    |    ______|

EOF
    echo -e "${NC}${CYAN}HyprDots Installation Script v2.1${NC}"
    echo -e "This will install and configure your Hyprland compositor with smart configurations."
    echo
    
    check_permissions
    check_system
    
    read -p "Start installation? (y/n): " c
    [[ $c != [yY] ]] && exit 0
    
    update_system
    backup_configs
    install_pacman_packages
    install_yay
    install_aur_packages
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
    log_info "  ✓ Configured GTK themes"
    log_info "  ✓ Set up user services"
    log_info "  ✓ Applied proper file permissions"
    log_info "  ✓ Updated font and icon caches"
    echo
    log_warning "Please reboot to apply all changes and start the desktop environment."
    log_info "After reboot, you may need to select 'Hyprland (uwsm)' from your display manager."
    
    read -p "Reboot now? (y/n): " r
    [[ $r == [yY] ]] && sudo reboot
}

main "$@"
