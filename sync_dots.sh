#!/usr/bin/env bash

# Define source and destination base directories
SOURCE_DIR="$HOME"
DEST_DIR="$HOME/GitHub/HyprDots"

# Array of paths to sync (relative to SOURCE_DIR)
# Add or remove paths as needed
SYNC_PATHS=(
    ".zshrc"
    ".zshenv"
    ".config/Code/User/keybindings.json"
    ".config/Code/User/settings.json"
    ".config/mimeapps.list"
    ".config/starship.toml"
    ".config/hypr"
    ".config/dunst"
    ".config/kitty"
    ".config/mpv"
    ".config/nvim"
    ".config/rofi"
    ".config/systemd"
    ".config/waybar"
    ".config/yazi"
    ".config/zathura"
    ".local/bin"
)

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to create parent directories if they don't exist
ensure_parent_dir() {
    local dest="$1"
    local parent_dir=$(dirname "$dest")
    if [ ! -d "$parent_dir" ]; then
        mkdir -p "$parent_dir"
        echo -e "${YELLOW}Created directory: $parent_dir${NC}"
    fi
}

# Function to sync a single path
sync_path() {
    local rel_path="$1"
    local source="$SOURCE_DIR/$rel_path"
    local dest="$DEST_DIR/$rel_path"

    # Check if source exists
    if [ ! -e "$source" ]; then
        echo -e "${YELLOW}Warning: Source path does not exist: $source${NC}"
        return
    fi

    # Ensure parent directory exists
    ensure_parent_dir "$dest"

    # Remove destination if it exists
    if [ -e "$dest" ]; then
        rm -rf "$dest"
    fi

    # Perform the sync
    if [ -d "$source" ]; then
        # For directories, copy recursively
        cp -r "$source" "$(dirname "$dest")/"
    else
        # For files, use simple copy
        cp "$source" "$dest"
    fi

    echo -e "${GREEN}Synced: $rel_path${NC}"
}

# Main script
echo "Starting dotfiles sync..."
echo "Source: $SOURCE_DIR"
echo "Destination: $DEST_DIR"
echo

# Create destination directory if it doesn't exist
mkdir -p "$DEST_DIR"

# Sync each path
for path in "${SYNC_PATHS[@]}"; do
    sync_path "$path"
done

echo -e "\n${GREEN}Sync complete!${NC}"
