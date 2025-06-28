#!/bin/bash

# Color definitions
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Logging functions
log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }
log_step() { echo -e "${BLUE}[STEP]${NC} $1"; }
log_success() { echo -e "${CYAN}[SUCCESS]${NC} $1"; }

# Package lists
PACMAN_PACKAGES=(
    "hyprland" "waybar" "dunst" "hypridle" "hyprlock"
    "sddm" "polkit-kde-agent" "xdg-desktop-portal-hyprland"
    "xdg-desktop-portal-gtk" "pipewire" "pipewire-pulse"
    "qt5-wayland" "qt6-wayland" "wireplumber" "uwsm"
    "kitty" "zsh" "starship" "eza" "fastfetch" "lolcat"
    "7zip" "aria2" "cliphist" "grim" "slurp" "brightnessctl"
    "udiskie" "unzip" "mediainfo" "openssh"
    "kde-cli-tools" "kdegraphics-thumbnailers" "qt5ct"
    "ripgrep" "kvantum" "bluez" "bluez-utils"
    "mpv" "ffmpegthumbs" "imagemagick" "imv" "speech-dispatcher"
    "noto-fonts" "noto-fonts-cjk" "noto-fonts-emoji"
    "ttf-cascadia-mono-nerd" "ttf-jetbrains-mono-nerd" "ttf-hack-nerd"
    "ttf-ubuntu-nerd" "ttf-dejavu-nerd" "ttf-font-awesome"
    "dolphin" "qbittorrent" "zathura" "zathura-cb" "zathura-pdf-mupdf"
    "neovim" "swww" "yazi"
)

AUR_PACKAGES=(
    "ianny" "qt6ct-kde" "rofi-calc-git" "rofi-emoji-git"
    "apple-fonts" "nomacs" "zen-browser-bin"
    "kvantum-theme-whitesur-git"
    "whitesur-gtk-theme"
    "whitesur-icon-theme"
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
        ".zshrc" ".zshenv"
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

    [[ -d ".config" ]] && cp -r .config/* "$HOME/.config/" && log_info "Copied .config files"
    [[ -d ".local" ]] && cp -r .local/* "$HOME/.local/" && log_info "Copied .local files"
    [[ -d ".walls" ]] && cp -r .walls/* "$HOME/Pictures/Wallpapers/" 2>/dev/null && log_info "Copied wallpapers"

    log_success "Config files installed."
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

install_omz() {
    log_step "Setting up Zsh + plugins"
    command -v zsh &>/dev/null || { log_error "Zsh not installed."; exit 1; }
    [[ -d "$HOME/.oh-my-zsh" ]] || sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
    declare -A plugins=(
        ["zsh-autosuggestions"]="https://github.com/zsh-users/zsh-autosuggestions.git"
        ["zsh-syntax-highlighting"]="https://github.com/zsh-users/zsh-syntax-highlighting.git"
        ["zsh-autocomplete"]="https://github.com/marlonrichert/zsh-autocomplete.git"
    )
    for name in "${!plugins[@]}"; do
        [[ ! -d "$ZSH_CUSTOM/plugins/$name" ]] && git clone --depth 1 "${plugins[$name]}" "$ZSH_CUSTOM/plugins/$name"
    done
    cp .zshrc "$HOME/.zshrc" 2>/dev/null || log_warning "Could not copy .zshrc"
    cp .zshenv "$HOME/.zshenv" 2>/dev/null || log_warning "Could not copy .zshenv"
    [[ "$SHELL" != *"zsh"* ]] && chsh -s "$(which zsh)" || log_warning "Failed to set zsh as default shell"
    log_success "Zsh configured."
}

configure_services() {
    log_step "Enabling services"
    systemctl --user enable --now pipewire.service pipewire-pulse.service wireplumber.service
    command -v hypridle &>/dev/null && systemctl --user enable --now hypridle.service
    sudo systemctl enable sddm.service
    pacman -Q bluez bluez-utils &>/dev/null && sudo systemctl enable bluetooth.service
    log_success "Services configured."
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
    echo -e "${NC}${CYAN}HyprDots Installation Script${NC}"
    echo -e "This will install and configure your Hyprland compositor."
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
    install_cursors
    install_omz
    configure_services
    echo
    log_success "HyprDots installation complete!"
    log_warning "Please reboot to apply all changes."
    read -p "Reboot now? (y/n): " r
    [[ $r == [yY] ]] && sudo reboot
}

main
