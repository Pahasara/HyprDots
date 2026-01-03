# ──────────────────────────────────────────────────────────────
# CORE ENVIRONMENT
# ──────────────────────────────────────────────────────────────
export LANG="en_US.UTF-8"
export EDITOR="nvim"
export VISUAL="nvim"
export DIFFPROG="kompare"

# ──────────────────────────────────────────────────────────────
# DIRECTORIES & PATHS
# ──────────────────────────────────────────────────────────────
export SCRIPT_DIR="$HOME/.local/bin"
export WALL_DIR="$HOME/Pictures/Wallpapers"
export SHADER_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/shader_cache"
export JETBRAINS="$HOME/.local/share/JetBrains/Toolbox/scripts"
export GOPATH="$HOME/.go"

export DOTNET_ROOT="/usr/share/dotnet"
export DOTNET_TOOLS_PATH="$HOME/.dotnet/tools"

# PATH Setup
export PATH="$JETBRAINS:$SCRIPT_DIR:$DOTNET_ROOT:$DOTNET_TOOLS_PATH:$PATH"

# ──────────────────────────────────────────────────────────────
# BUILD & COMPRESSION OPTIMIZATIONS
# ──────────────────────────────────────────────────────────────
# Build Tools
NPROC="$(nproc)"
export MAKEFLAGS="-j$NPROC"
export CMAKE_BUILD_PARALLEL_LEVEL="$NPROC"
export NINJA_NUM_CORES="$NPROC"

# Compiler Flags
export CFLAGS="-O3 -march=native -pipe"
export CXXFLAGS="$CFLAGS"

# Compression Tools
export ZSTD_CLEVEL=12
export ZSTD_NBTHREADS="$NPROC"
export XZ_DEFAULTS="-T$NPROC"
export GZIP=-9

# ──────────────────────────────────────────────────────────────
# MAN PAGER CONFIGURATION
# ──────────────────────────────────────────────────────────────
export BAT_THEME="tokyonight_night"
export MANROFFOPT="-c"
# Pipe `man` output through bat for highlighting
export MANPAGER="sh -c 'sed -u -e \"s/\\x1B\\[[0-9;]*m//g; s/.\\x08//g\" | bat -p -l man'"

# ──────────────────────────────────────────────────────────────
# TELEMETRY & DEBUGGING FLAGS
# ──────────────────────────────────────────────────────────────
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export DOTNET_HTTPREPL_TELEMETRY_OPTOUT=1
export ANV_DEBUG="video-decode,video-encode"

