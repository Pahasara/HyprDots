# ──────────────────────────────────────────────────────────────
# ZINIT BOOTSTRAP
# ──────────────────────────────────────────────────────────────
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

[[ ! -d $ZINIT_HOME ]] && mkdir -p "$(dirname "$ZINIT_HOME")" && \
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"

source "${ZINIT_HOME}/zinit.zsh"

# ──────────────────────────────────────────────────────────────
# XDG & COMPDUMP
# ──────────────────────────────────────────────────────────────
export ZDOTDIR="$HOME"

# ──────────────────────────────────────────────────────────────
# HISTORY SETTINGS
# ──────────────────────────────────────────────────────────────
export HISTSIZE=100000
export SAVEHIST=50000
export HISTFILE="${XDG_CACHE_HOME:-${HOME}/.cache}/zsh/zsh_history"

setopt AUTO_CD NO_CASE_GLOB PROMPT_SUBST
setopt EXTENDED_HISTORY INC_APPEND_HISTORY
setopt HIST_IGNORE_SPACE HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS HIST_FIND_NO_DUPS
setopt HIST_EXPIRE_DUPS_FIRST HIST_REDUCE_BLANKS HIST_VERIFY

# ──────────────────────────────────────────────────────────────
# COMPLETION SYSTEM STYLES
# ──────────────────────────────────────────────────────────────
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-${HOME}/.cache}/zsh/compcache"
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu select
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' max-errors 0
zstyle ':completion:*' accept-exact '*(N)'

# ──────────────────────────────────────────────────────────────
# FZF-TAB STYLES
# ──────────────────────────────────────────────────────────────
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:*' fzf-flags --height=60% --preview-window=right:40%
zstyle ':fzf-tab:*' switch-group '<' '>'
zstyle ':fzf-tab:*' continuous-trigger '/'
zstyle ':fzf-tab:*' fzf-flags --bind=tab:accept

# ──────────────────────────────────────────────────────────────
# AUTOSUGGESTIONS CONFIG
# ──────────────────────────────────────────────────────────────
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_HISTORY_IGNORE="?(#c50,)"
ZSH_AUTOSUGGEST_MANUAL_REBIND=1

# ──────────────────────────────────────────────────────────────
# HISTORY SEARCH CONFIG
# ──────────────────────────────────────────────────────────────
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='fg=blue,bold'
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='fg=magenta,bold'

# ──────────────────────────────────────────────────────────────
# PLUGINS
# ──────────────────────────────────────────────────────────────
# Load fzf-tab synchronously
zinit light Aloxaf/fzf-tab

# 1. Autosuggestions + Compinit
zinit wait'0a' lucid light-mode for \
    atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
    atload"!_zsh_autosuggest_start; bindkey '^@' autosuggest-accept" \
        zsh-users/zsh-autosuggestions

# 2. Syntax highlighting
zinit wait'0b' lucid light-mode for \
        zdharma-continuum/fast-syntax-highlighting

# 3. History Substring Search
zinit wait'0c' lucid light-mode for \
    atload"bindkey '^[[A' history-substring-search-up; \
           bindkey '^[[B' history-substring-search-down; \
           bindkey '^k' history-substring-search-up; \
           bindkey '^j' history-substring-search-down; \
           _zsh_autosuggest_bind_widgets" \
        zsh-users/zsh-history-substring-search

zinit wait'1' lucid light-mode for \
    MichaelAquilina/zsh-you-should-use \
    OMZP::git

# ──────────────────────────────────────────────────────────────
# STARSHIP & ZOXIDE INIT
# ──────────────────────────────────────────────────────────────
eval "$(starship init zsh)"
eval "$(zoxide init --cmd cd zsh)"

# ──────────────────────────────────────────────────────────────
# LOCAL CONFIG FILES
# ──────────────────────────────────────────────────────────────
[[ -f ~/.zsh_aliases ]] && source ~/.zsh_aliases
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# ──────────────────────────────────────────────────────────────
# STARTUP MESSAGE
# ──────────────────────────────────────────────────────────────
() {
    local marker="/tmp/.zsh_greeted_$(date +%Y%m%d)"
    [[ -f $marker ]] && return
    if command -v lolcat >/dev/null 2>&1; then
        [[ -f ~/.arch ]] && cat ~/.arch | lolcat
        echo "Welcome, $USER!" | lolcat
    fi
    touch "$marker"
}

