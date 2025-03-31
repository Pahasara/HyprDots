#!/bin/bash

# Color definitions
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Logging functions
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

log_success() {
    echo -e "${CYAN}[SUCCESS]${NC} $1"
}

# Package lists
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
    "7zip" "aria2" "cliphist" "grim" "slurp" "brightnessctl" 
    "udiskie" "unzip" "mediainfo" "openssh"
    "kde-cli-tools" "kdegraphics-thumbnailers" "qt5ct" 
    "ripgrep" "kvantum" "bluez" "bluez-utils"

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

# List of archive files to extract after copying
THEME_ARCHIVES=(
    "$HOME/.themes/Colloid-Dark.tar.xz"
    "$HOME/.icons/McMojave-hyprcursor.tar.xz"
    "$HOME/.icons/McMojave-cursors.tar.xz"
    "$HOME/.local/share/icons/BigSur.tar.xz"
)

# Check if script is run by root
check_permissions() {
    if [[ $EUID -eq 0 ]]; then
        log_error "Do not run this script with sudo. Run as a normal user."
        exit 1
    fi
}

# Check for Arch-based distro
check_system() {
    if ! command -v pacman &> /dev/null; then
        log_error "This script is designed for Arch-based distributions only."
        exit 1
    fi
    
    log_info "System check passed. Continuing installation..."
}

# Update system packages
update_system() {
    log_step "Updating system packages"
    sudo pacman -Syu --noconfirm || {
        log_warning "System update completed with some warnings. Continuing..."
    }
}

# Create backup of existing configurations
backup_configs() {
    local backup_dir="$HOME/hyprdots_backup_$(date +%Y%m%d_%H%M%S)"
    
    log_step "Creating backup of existing configurations to $backup_dir"
    
    mkdir -p "$backup_dir"
    
    local items_to_backup=(
        ".config/hypr"
        ".config/waybar"
        ".config/dunst"
        ".config/rofi"
        ".config/kitty"
        ".config/yazi"
        ".config/neovim"
        ".config/mpv"
        ".zshrc"
        ".zshenv"
    )
    
    for item in "${items_to_backup[@]}"; do
        if [ -e "$HOME/$item" ]; then
            mkdir -p "$(dirname "$backup_dir/$item")"
            cp -r "$HOME/$item" "$backup_dir/$item"
            log_info "Backed up $item to $backup_dir"
        fi
    done
    
    log_success "Backup completed. Your original files are saved in $backup_dir"
}

# Install packages from official repositories
install_pacman_packages() {
    log_step "Installing packages from official repositories"
    
    # Check for existing packages to avoid reinstalling
    local to_install=()
    for pkg in "${PACMAN_PACKAGES[@]}"; do
        if ! pacman -Q "$pkg" &> /dev/null; then
            to_install+=("$pkg")
        fi
    done
    
    if [ ${#to_install[@]} -eq 0 ]; then
        log_info "All official packages are already installed."
    else
        log_info "Installing ${#to_install[@]} packages..."
        sudo pacman -S --needed --noconfirm "${to_install[@]}" || {
            log_error "Failed to install some packages. Please check the output above."
            read -p "Do you want to continue anyway? (y/n): " continue_choice
            [[ $continue_choice != [yY] ]] && exit 1
        }
    fi
}

# Install yay AUR helper
install_yay() {
    log_step "Checking for AUR helper (yay)"
    
    if command -v yay &> /dev/null; then
        log_info "Yay is already installed."
        return 0
    fi
    
    log_info "Installing Yay AUR helper..."
    
    # Dependencies for yay
    sudo pacman -S --needed --noconfirm git base-devel
    
    # Create temp directory and clone yay
    local temp_dir=$(mktemp -d)
    git clone https://aur.archlinux.org/yay.git "$temp_dir"
    cd "$temp_dir" || {
        log_error "Failed to navigate to temporary directory for yay installation."
        exit 1
    }
    
    # Build and install yay
    makepkg -si --noconfirm || {
        log_error "Failed to install yay. Please install it manually."
        exit 1
    }
    
    # Clean up
    cd - > /dev/null
    rm -rf "$temp_dir"
    
    log_success "Yay installed successfully."
}

# Install packages from AUR
install_aur_packages() {
    log_step "Installing packages from AUR"
    
    # Check for existing packages to avoid reinstalling
    local to_install=()
    for pkg in "${AUR_PACKAGES[@]}"; do
        if ! yay -Q "$pkg" &> /dev/null; then
            to_install+=("$pkg")
        fi
    done
    
    if [ ${#to_install[@]} -eq 0 ]; then
        log_info "All AUR packages are already installed."
    else
        log_info "Installing ${#to_install[@]} AUR packages..."
        yay -S --needed --noconfirm "${to_install[@]}" || {
            log_warning "Some AUR packages may have failed to install."
            read -p "Do you want to continue anyway? (y/n): " continue_choice
            [[ $continue_choice != [yY] ]] && exit 1
        }
    fi
}

# Install dotfiles
install_dotfiles() {
    log_step "Installing HyprDots configuration files"

    # Create necessary directories
    mkdir -p "$HOME/.config"
    mkdir -p "$HOME/.local/bin"
    mkdir -p "$HOME/.local/share"
    mkdir -p "$HOME/Pictures/Wallpapers"
    mkdir -p "$HOME/.themes"
    mkdir -p "$HOME/.icons"
    mkdir -p "$HOME/.local/share/icons"
    
    # Copy configuration files
    if [ -d ".config" ]; then
        cp -r ".config/"* "$HOME/.config/" || log_warning "Error copying .config files"
        log_info "Copied configuration files to ~/.config/"
    else
        log_error "Config directory not found! Make sure you're running this from the HyprDots directory."
        exit 1
    fi
    
    # Copy local files
    if [ -d ".local" ]; then
        cp -r ".local/"* "$HOME/.local/" || log_warning "Error copying .local files"
        log_info "Copied local files to ~/.local/"
    fi
    
    # Copy theme files
    if [ -d ".themes" ]; then
        cp -r ".themes/"* "$HOME/.themes/" || log_warning "Error copying theme files"
        log_info "Copied theme files to ~/.themes/"
    fi
    
    # Copy icon files
    if [ -d ".icons" ]; then
        cp -r ".icons/"* "$HOME/.icons/" || log_warning "Error copying icon files"
        log_info "Copied icon files to ~/.icons/"
    fi
    
    # Copy wallpapers if they exist
    if [ -d ".walls" ]; then
        cp -r ".walls/"* "$HOME/Pictures/Wallpapers/" 2>/dev/null || log_warning "Error copying wallpapers"
        log_info "Copied wallpapers to ~/Pictures/Wallpapers/"
    fi
    
    log_success "HyprDots files installed successfully."
}

# Extract compressed theme/icon archives
extract_theme_archives() {
    log_step "Extracting theme and icon archives"
    
    local extracted_count=0
    
    for archive in "${THEME_ARCHIVES[@]}"; do
        if [ -f "$archive" ]; then
            log_info "Extracting $(basename "$archive")"
            
            # Get the directory where the archive is located
            local extract_dir=$(dirname "$archive")
            
            # Extract the archive
            tar -xf "$archive" -C "$extract_dir" && {
                # Remove the archive after successful extraction
                rm "$archive" && log_info "Removed archive after extraction"
                ((extracted_count++))
            } || {
                log_warning "Failed to extract: $archive"
            }
        else
            log_warning "Archive not found: $archive"
        fi
    done
    
    if [ $extracted_count -eq ${#THEME_ARCHIVES[@]} ]; then
        log_success "All theme and icon archives extracted successfully"
    else
        log_warning "Extracted $extracted_count out of ${#THEME_ARCHIVES[@]} archives"
    fi
}

# Install Oh My Zsh and plugins
install_omz() {
    log_step "Setting up Zsh environment"
    
    # Check if zsh is installed
    if ! command -v zsh &> /dev/null; then
        log_error "Zsh is not installed. Please run the script again after fixing this issue."
        exit 1
    fi
    
    # Check if Oh My Zsh is already installed
    if [ -d "$HOME/.oh-my-zsh" ]; then
        log_info "Oh My Zsh is already installed."
    else
        log_info "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi
    
    # Set up plugins directory
    ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
    
    # Install plugins
    log_info "Installing Zsh plugins..."
    
    plugin_repos=(
        "https://github.com/zsh-users/zsh-autosuggestions.git"
        "https://github.com/zsh-users/zsh-syntax-highlighting.git"
        "https://github.com/marlonrichert/zsh-autocomplete.git"
    )
    
    plugin_dirs=(
        "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
        "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
        "$ZSH_CUSTOM/plugins/zsh-autocomplete"
    )
    
    for i in "${!plugin_repos[@]}"; do
        if [ ! -d "${plugin_dirs[$i]}" ]; then
            git clone --depth 1 "${plugin_repos[$i]}" "${plugin_dirs[$i]}" || log_warning "Failed to clone ${plugin_repos[$i]}"
        else
            log_info "Plugin ${plugin_dirs[$i]} already installed."
        fi
    done
    
    # Copy zsh configuration files
    cp ".zshrc" "$HOME/.zshrc" 2>/dev/null || log_warning "Error copying .zshrc"
    cp ".zshenv" "$HOME/.zshenv" 2>/dev/null || log_warning "Error copying .zshenv"
    
    # Set zsh as default shell
    if [[ "$SHELL" != *"zsh"* ]]; then
        log_info "Setting Zsh as default shell..."
        chsh -s $(which zsh) || log_warning "Failed to set Zsh as default shell. You can do this manually later."
    fi
    
    log_success "Zsh setup completed."
}

# Configure and enable system services
configure_services() {
    log_step "Configuring system services"
    
    # Enable user services
    log_info "Enabling user services..."
    systemctl --user enable pipewire.service || log_warning "Failed to enable pipewire.service"
    systemctl --user enable pipewire-pulse.service || log_warning "Failed to enable pipewire-pulse.service"
    systemctl --user enable wireplumber.service || log_warning "Failed to enable wireplumber.service"
    
    # Try to start user services
    log_info "Starting user services..."
    systemctl --user start pipewire.service || log_warning "Failed to start pipewire.service"
    systemctl --user start pipewire-pulse.service || log_warning "Failed to start pipewire-pulse.service"
    systemctl --user start wireplumber.service || log_warning "Failed to start wireplumber.service"
    
    # Enable hypridle only if it exists
    if command -v hypridle &> /dev/null; then
        systemctl --user enable hypridle.service || log_warning "Failed to enable hypridle.service"
        systemctl --user start hypridle.service || log_warning "Failed to start hypridle.service"
    else
        log_warning "Hypridle not found. Skipping service setup."
    fi

    # Enable system services
    log_info "Enabling system services..."
    sudo systemctl enable sddm.service || log_warning "Failed to enable sddm.service"
    
    # Enable Bluetooth if available
    if pacman -Q bluez bluez-utils &> /dev/null; then
        log_info "Enabling Bluetooth service..."
        sudo systemctl enable bluetooth.service || log_warning "Failed to enable bluetooth.service"
    fi
    
    log_success "Services configured."
}

# Main installation function
main() {
    clear

    # Print ASCII art header
    echo -e "${GREEN}"
    cat << "EOF"
                                                          shinzo™
 _     _ __   __  _____   ______ ______   _____  _______ _______
 |_____|   \_/   |_____] |_____/ |     \ |     |    |    |______
 |     |    |    |       |    \_ |_____/ |_____|    |    ______|

EOF
    echo -e "${NC}"
    echo -e "${CYAN}HyprDots Installation Script${NC}"
    echo -e "This will install HyprDots and configure your system."
    echo

    # Check basic requirements
    check_permissions
    check_system
    
    # Confirm installation
    echo
    read -p "Do you want to start the HyprDots installation? (y/n): " confirm
    if [[ $confirm != [yY] ]]; then
        log_info "Installation aborted by user."
        exit 0
    fi
    
    # Run installation steps
    update_system
    backup_configs
    install_pacman_packages
    install_yay
    install_aur_packages
    install_dotfiles
    extract_theme_archives
    install_omz
    configure_services
    
    # Installation complete
    echo
    log_success "HyprDots installation complete!"
    log_success "Welcome to your new Hyprland desktop environment!"
    echo
    log_warning "Please reboot your system to apply all changes."
    echo
    
    # Prompt for reboot
    read -p "Would you like to reboot now? (y/n): " reboot_choice
    if [[ $reboot_choice == [yY] ]]; then
        log_info "Rebooting system..."
        sudo reboot
    else
        log_info "Remember to reboot later to fully apply the changes."
    fi
}

# Run the main function
main
