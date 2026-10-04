# ──────────────────────────────────────────────────────────────
# CORE ENVIRONMENT
# ──────────────────────────────────────────────────────────────
export LANG="en_US.UTF-8"
export EDITOR="nvim"
export VISUAL="nvim"
export DIFFPROG="kompare"
export BROWSER="firefox"

# ──────────────────────────────────────────────────────────────
# DIRECTORIES & PATHS
# ──────────────────────────────────────────────────────────────
export WALL_DIR="$HOME/Pictures/Wallpapers"
export SHADER_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/shader_cache"
export GOPATH="$HOME/.go"

export SCRIPT_DIR="$HOME/.local/bin"
export JETBRAINS="$HOME/.local/share/JetBrains/Toolbox/scripts"
export XDG_BIN_HOME="$SCRIPT_DIR"

# Ensure PATH includes ccache and custom scripts
export PATH="/usr/lib/ccache/bin:$JETBRAINS:$SCRIPT_DIR:$PATH"
export CCACHE_PATH="/usr/bin"

# ──────────────────────────────────────────────────────────────
# BUILD & PARALLELIZATION OPTIMIZATIONS
# ──────────────────────────────────────────────────────────────
# Dynamically scale parallel builds to N threads
NPROC="$(nproc)"
export MAKEFLAGS="-j$NPROC"
export CMAKE_BUILD_PARALLEL_LEVEL="$NPROC"
export NINJA_NUM_CORES="$NPROC"

# Global Compression Settings
export ZSTD_CLEVEL=6
export ZSTD_NBTHREADS="0"
export XZ_DEFAULTS="-T0"
export GZIP="-9"

# GCC Diagnostics Color Support
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# ──────────────────────────────────────────────────────────────
# MAN PAGER CONFIGURATION
# ──────────────────────────────────────────────────────────────
export BAT_THEME="tokyonight_night"
export MANROFFOPT="-c"
export MANPAGER="sh -c 'sed -u -e \"s/\\x1B\\[[0-9;]*m//g; s/.\\x08//g\" | bat -p -l man'"
export TLDR_COLOR_NAME="magenta"
export TLDR_COLOR_DESCRIPTION="blue"
export TLDR_COLOR_EXAMPLE="red"
export TLDR_COLOR_COMMAND="green"

# ──────────────────────────────────────────────────────────────
# TELEMETRY & DEBUG
# ──────────────────────────────────────────────────────────────
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export TESTINGPLATFORM_TELEMETRY_OPTOUT=1
export DOTNET_HTTPREPL_TELEMETRY_OPTOUT=1
export TURBO_TELEMETRY_DISABLED=1
export DO_NOT_TRACK=1

export ANV_DEBUG="video-decode,video-encode"
