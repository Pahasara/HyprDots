#############
#  GENERAL  #
#############
export ZSH="$HOME/.oh-my-zsh"

zstyle ':omz:update' mode reminder  # just remind me to update when it's time

zstyle ':omz:update' frequency 13   # how often to auto-update (in days).

# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="robbyrussell"

CASE_SENSITIVE="false"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

DISABLE_LS_COLORS="false"

DISABLE_AUTO_TITLE="false"

ENABLE_CORRECTION="true"

COMPLETION_WAITING_DOTS="false"


#############
#  PLUGINS  #
#############
plugins=(
	git
	zsh-autosuggestions
	zsh-autocomplete
	zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

eval "$(starship init zsh)"  # Star Ship theme


########################
#  User configuration  #
########################
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Man page highlighting with nvim
# export MANPAGER="nvim +Man!"

# Man page highlighting with bat
export MANPAGER="sh -c 'col -bx | bat -l man -p --theme default'"
export MANROFFOPT="-c"


######################
#      ALIASES       #
######################
alias :q="exit"
alias py="python"
alias nf="neofetch"
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias ls='eza --icons --color=always --group-directories-first'
alias ll='eza -alF --icons --color=always --group-directories-first'
alias la='eza -a --icons --color=always --group-directories-first'
alias l='eza -F --icons --color=always --group-directories-first'
alias l.='eza -a | egrep "^\."'
