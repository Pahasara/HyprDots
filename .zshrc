##################
#   ZSH CONFIG   #
##################

# Update check: prompt every 21 days
zstyle ':omz:update' mode reminder
zstyle ':omz:update' frequency 21

# Behavior options
CASE_SENSITIVE="false"
DISABLE_LS_COLORS="false"
DISABLE_AUTO_TITLE="false"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="false"

################
#   HISTORY    #
################
export HISTSIZE=100000
export SAVEHIST=100000
export HISTDUP=erase

setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_SPACE
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_FIND_NO_DUPS

################
#   PLUGINS    #
################
plugins=(
  git
  zsh-autosuggestions
  zsh-autocomplete
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

###############
#   CUSTOM    #
###############
# Load aliases from a separate file
[[ -f ~/.zsh_aliases ]] && source ~/.zsh_aliases

# Source local config if it exists
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

################
#   STARTUP    #
################
# Custom welcome messages
[[ -f ~/.arch ]] && cat ~/.arch | lolcat
echo "Welcome, $USER!" | lolcat

# Start Starship prompt
eval "$(starship init zsh)"

# Start zoxide
eval "$(zoxide init --cmd cd zsh)"

