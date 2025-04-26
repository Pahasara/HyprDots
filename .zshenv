# zsh paths
export ZSH="$HOME/.oh-my-zsh"
export ZSH_COMPDUMP=$ZSH/cache/.zcompdump-$HOST-$ZSH_VERSION
export HISTFILE=$ZSH/cache/.zsh_history
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nvim'
else
  export EDITOR='nvim'
fi
export VISUAL='nvim'

# bat customization
export BAT_THEME="tokyonight_night"
export MANPAGER="sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | bat -p -lman'"
export MANROFFOPT="-c"

# Add path for .local/bin/* scripts
export PATH=$HOME/.local/bin:$PATH

# mesa shader cache -custom path
export SHADER_CACHE=$HOME/.cache/mesa_shader_cache
