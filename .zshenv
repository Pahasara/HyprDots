# ─── Locale ────────────────────────────────────────────────
export LANG="en_US.UTF-8"

# ─── Oh-My-Zsh ─────────────────────────────────────────────
export ZSH="$HOME/.oh-my-zsh"
export ZSH_COMPDUMP="$ZSH/cache/.zcompdump-$HOST-$ZSH_VERSION"
export HISTFILE="$ZSH/cache/.zsh_history"

# ─── Custom Paths ──────────────────────────────────────────
export SCRIPT_DIR="$HOME/.local/bin"
export WALL_DIR="$HOME/Pictures/Wallpapers"
export SHADER_CACHE_DIR="$XDG_CACHE_HOME/mesa_shader_cache"

# ─── Editor ────────────────────────────────────────────────
# Use Neovim as default editor in all contexts
export EDITOR="nvim"
export VISUAL="nvim"

# ─── Diff Tool ─────────────────────────────────────────────
export DIFFPROG="kompare"

# ─── BAT (Better `cat`) ────────────────────────────────────
export BAT_THEME="tokyonight_night"

# Use `bat` to render manpages with syntax highlighting and clean formatting
export MANPAGER="sh -c 'sed -u -e \"s/\\x1B\\[[0-9;]*m//g; s/.\\x08//g\" | bat -p -l man'"
export MANROFFOPT="-c"

# ─── Compression ───────────────────────────────────────────
export ZSTD_CLEVEL=12  # Default Zstandard compression level

# ─── PATH ──────────────────────────────────────────────────
export PATH="$SCRIPT_DIR:$PATH"             # Add user scripts to PATH
export PATH="$PATH:$HOME/.dotnet/tools"     # Add .NET global tools to PATH

