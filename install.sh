#!/bin/bash

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_step() {
    echo -e "${BLUE}[STEP]${NC} $1"
}

PACMAN_PACKAGES=(
    # System and desktop environment
    "hyprland" "waybar" "dunst" "hypridle" "hyprlock" 
    "sddm" "polkit-kde-agent" "xdg-desktop-portal-hyprland" 
    "xdg-desktop-portal-gtk" "pipewire" "pipewire-pulse"
    "qt5-wayland" "qt6-wayland" "wireplumber"
    
    # Terminal and shell
    "kitty" "zsh"
    "starship" "eza" "fastfetch"

    # Utilities
    "7zip" aria2" "cliphist" "grim" "slurp" "brightnessctl" 
    "udiskie" "unzip" "mediainfo" "openssh"
    "kde-cli-tools" "kdegraphics-thumbnailers" "qt5ct" 
    "nodejs" "npm" "ripgrep" "kvantum"

    # Multimedia
    "mpv" "ffmpegthumbs" "imagemagick" "imv" "speech-dispatcher" 

    # Fonts and themes
    "noto-fonts" "noto-fonts-cjk" "noto-fonts-emoji"
    "ttf-cascadia-mono-nerd" "ttf-dejavu-nerd" "ttf-font-awesome"
    "ttf-jetbrains-mono-nerd" "ttf-ubuntu-nerd" "ttf-hack-nerd"

    # Applications
    "dolphin" "qbittorrent" "zathura" "zathura-cb" "zathura-pdf-mupdf" 
    "neovim" "swww" "yazi"
)

AUR_PACKAGES=(
    "ianny-git" 
    "qt6ct-kde" 
    "rofi-calc-git" 
    "rofi-emoji-git" 
    "ttf-ms-win11-auto"
    "uwsm"
    "zen-browser-bin"
)

check_permissions() {
    if [[ $EUID -eq 0 ]]; then
        log_error "Do not run this script with sudo. Run as a normal user."
        exit 1
    fi
}

update_system() {
    sudo pacman -Syu --noconfirm || true
}

backup_configs() {
    local backup_dir="$HOME/backup_config"
    
    log_step "Creating backup of existing configurations"
    
    mkdir -p "$backup_dir"
    
    local items_to_backup=(
        ".config"
        ".local"
        ".zshrc"
        ".zshenv"
    )
    
    for item in "${items_to_backup[@]}"; do
        if [ -e "$HOME/$item" ]; then
            cp -r "$HOME/$item" "$backup_dir/$item"
            log_info "Backed up $item to $backup_dir"
        fi
    done
}

install_pacman_packages() {
    log_step "Installing Pacman packages"
    sudo pacman -S --noconfirm "${PACMAN_PACKAGES[@]}"
}

install_yay() {
    log_step "Installing Yay (AUR helper)"
    
    if [ ! command -v yay &>/dev/null ]; then
        git clone https://aur.archlinux.org/yay.git
        cd yay || exit
        makepkg -si --noconfirm
    fi
}

install_aur_packages() {
    log_step "Installing AUR packages"
    yay -S --noconfirm "${AUR_PACKAGES[@]}"
}

install_dotfiles() {
    log_step "Installing dotfiles"

    cp -r ".local" "$HOME/"
    cp -r ".config" "$HOME/"
    
    mkdir -p "$HOME/Pictures"
    cp -r ".walls"/* "$HOME/Pictures/" 2>/dev/null
}

install_omz() {
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
    git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git $ZSH_CUSTOM/plugins/zsh-autocomplete
    chsh -s $(which zsh) || true
    cp ".zshrc" "$HOME/"
    cp ".zshenv" "$HOME/"
}

configure_services() {
    log_step "Configuring system services"
    systemctl --user enable --now pipewire pipewire-pulse wireplumber hypridle

    log_step "Enabling SDDM display manager"
    sudo systemctl enable sddm.service
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
    echo -e "${NC}"

    check_permissions
    
    read -p "Do you want to start the dotfiles installation? (y/n): " confirm
    [[ $confirm != [yY] ]] && exit 1

    update_system
    
    backup_configs
    
    install_pacman_packages
    
    install_yay
    
    install_aur_packages
    
    install_dotfiles

    install_omz

    configure_services
    
    log_info "Dotfiles installation complete!"

    # Prompt for reboot
    echo
    log_warning "Please reboot or log out and log in again to apply changes."
    echo
    read -p "Would you like to reboot now? (y/n): " reboot_choice
    [[ $reboot_choice == [yY] ]] && sudo reboot
}

main
