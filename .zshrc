#############
#  GENERAL  #
#############
export ZSH="$HOME/.oh-my-zsh"

zstyle ':omz:update' mode reminder  # just remind me to update when it's time

zstyle ':omz:update' frequency 13   # how often to auto-update (in days).

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


###########
# HISTORY #
###########
export HISTSIZE=10000
export SAVEHIST=10000
export HISTDUP=erase
setopt appendhistory
setopt SHARE_HISTORY
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups


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


###########
# ENVIRON #
###########
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi
export VISUAL='nvim'

# Man page highlighting with bat
export BAT_THEME="tokyonight_night"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANROFFOPT="-c"

# Add path for .local/bin/* scripts
export PATH=$HOME/.local/bin:$PATH

# Add path for javafx
export JAVA_FX_PATH=$HOME/.local/lib/javafx-sdk-21.0.5/lib


######################
#      ALIASES       #
######################
alias :q="exit"
alias ls='eza --icons --color=always --group-directories-first'
alias ll='eza -alF --icons --color=always --group-directories-first'
alias la='eza -a --icons --color=always --group-directories-first'
alias l='eza -F --icons --color=always --group-directories-first'
alias l.='eza -a | egrep "^\."'

alias z="./.local/bin/zero/Zero.CLI"
alias zero="./.local/bin/zero/Zero.CLI"
alias wall="swww img"
alias vz="vim ~/.zshrc"
alias vk="vim ~/.config/kitty/kitty.conf"
alias ns="notify-send 'Arch Linux' 'DAMN! You have not riced me since last month. Did u forget ur loving arch wifey..?' --urgency=normal"
alias xzz="XZ_OPT='-9' tar -cJf"
alias gzz="tar -czf"
alias zst="tar -I 'zstd -19 -T4' -cf"
alias cdc="cd && cd Code"
alias qpdf="qpdf --empty --pages"

alias vi="nvim"
alias vim="nvim"
alias ac="aria2c"
alias ff="fastfetch"
alias mk="musikcube"
alias mg="mega-get"
alias y="yazi"

alias py="python"
alias jr="java"
alias jc="javac"
alias db="dotnet build"
alias dr="dotnet run"
alias dpl="dotnet publish -r linux-x64 --sc"
alias dpw="dotnet publish -r win-x64 --sc"
alias gcc="gcc -Wall"
alias g++="g++ -Wall"
alias cl="clang -std=c23 -Wall"
alias cl++="clang++ -std=c++23 -Wall"

######################
#     STARSHIP       #
######################
eval "$(starship init zsh)"
