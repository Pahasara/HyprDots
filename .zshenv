# ──────────────────────────────────────────────────────────────
# Locale Settings
# ──────────────────────────────────────────────────────────────
export LANG="en_US.UTF-8"

# ──────────────────────────────────────────────────────────────
# Oh-My-Zsh Configuration
# ──────────────────────────────────────────────────────────────
export ZSH="$HOME/.oh-my-zsh"
export ZSH_COMPDUMP="$ZSH/cache/.zcompdump-$HOST-$ZSH_VERSION"
export HISTFILE="$ZSH/cache/.zsh_history"

# ──────────────────────────────────────────────────────────────
# Custom Directories & Paths
# ──────────────────────────────────────────────────────────────
export SCRIPT_DIR="$HOME/.local/bin"         # Custom user scripts directory
export WALL_DIR="$HOME/Pictures/Wallpapers"  # Wallpaper storage directory
export SHADER_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/mesa_shader_cache_custom"  # custom shader cache

# ──────────────────────────────────────────────────────────────
# Editor Configuration
# ──────────────────────────────────────────────────────────────
export EDITOR="nvim"      # Set Neovim as default editor
export VISUAL="nvim"

# ──────────────────────────────────────────────────────────────
# Diff Tools
# ──────────────────────────────────────────────────────────────
export DIFFPROG="kompare"  # Use Kompare for diffs

# ──────────────────────────────────────────────────────────────
# Better `cat` with BAT
# ──────────────────────────────────────────────────────────────
export BAT_THEME="tokyonight_night"    # BAT color theme

# Render manpages with syntax highlighting using bat
export MANPAGER="sh -c 'sed -u -e \"s/\\x1B\\[[0-9;]*m//g; s/.\\x08//g\" | bat -p -l man'"
export MANROFFOPT="-c"

# ──────────────────────────────────────────────────────────────
# Compression Settings
# ──────────────────────────────────────────────────────────────
export ZSTD_CLEVEL=12                      # Zstandard default compression level
export ZSTD_NBTHREADS="$(nproc)"           # Use all CPU cores for compression

# ──────────────────────────────────────────────────────────────
# .NET SDK & Tools
# ──────────────────────────────────────────────────────────────
export PATH="$PATH:$HOME/.dotnet/tools"     # Add .NET global tools to PATH
export DOTNET_CLI_TELEMETRY_OPTOUT=1        # Disable .NET telemetry

# ──────────────────────────────────────────────────────────────
# Experimental & Debugging Flags
# ──────────────────────────────────────────────────────────────
export ANV_DEBUG="video-decode,video-encode"  # Enable Vulkan video decode/encode

# ──────────────────────────────────────────────────────────────
# PATH Updates
# ──────────────────────────────────────────────────────────────
export PATH="$SCRIPT_DIR:$PATH"             # Prepend user scripts directory to PATH
