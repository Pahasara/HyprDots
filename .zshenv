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
export SHADER_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/shader_cache"

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
# Build Optimizations
# ──────────────────────────────────────────────────────────────
export MAKEFLAGS="-j$(nproc)"
export CMAKE_BUILD_PARALLEL_LEVEL="$(nproc)"
export NINJA_NUM_CORES="$(nproc)"
export CFLAGS="-O3 -march=native -pipe"
export CXXFLAGS="$CFLAGS"

# ──────────────────────────────────────────────────────────────
# Compression Settings
# ──────────────────────────────────────────────────────────────
export ZSTD_CLEVEL=12                      # Zstandard compression level
export ZSTD_NBTHREADS="$(nproc)"           # Use all CPU cores for compression
export XZ_DEFAULTS="-T$(nproc)"
export GZIP=-9

# ──────────────────────────────────────────────────────────────
# .NET SDK & Tools
# ──────────────────────────────────────────────────────────────
export DOTNET_ROOT="/usr/share/dotnet"
export DOTNET_TOOLS_PATH="$HOME/.dotnet/tools"
export DOTNET_CLI_TELEMETRY_OPTOUT=1           # Disable .NET telemetry
export DOTNET_HTTPREPL_TELEMETRY_OPTOUT=1      # Disable .NET-Http-REPL telemetry

# ──────────────────────────────────────────────────────────────
# Experimental & Debugging Flags
# ──────────────────────────────────────────────────────────────
export ANV_DEBUG="video-decode,video-encode"  # Enable Vulkan video decode/encode

# ──────────────────────────────────────────────────────────────
# PATH
# ──────────────────────────────────────────────────────────────
export PATH="$PATH:$SCRIPT_DIR"
export PATH="$PATH:$DOTNET_ROOT"
export PATH="$PATH:$DOTNET_TOOLS_PATH"

