#############
#  GENERAL  #
#############

zstyle ':omz:update' mode reminder
zstyle ':omz:update' frequency 21

CASE_SENSITIVE="false"
DISABLE_LS_COLORS="false"
DISABLE_AUTO_TITLE="false"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="false"


###########
# HISTORY #
###########
export HISTSIZE=100000
export SAVEHIST=100000
export HISTDUP=erase
setopt APPENDHISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_SPACE
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_FIND_NO_DUPS


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
alias ve="vim ~/.zshenv"
alias vk="vim ~/.config/kitty/kitty.conf"
alias ns="dunstify 'Arch Linux' 'DAMN! You have not riced me since last month. Did u forget ur loving arch wifey..?' -a System -u normal"
alias xzz="XZ_OPT='-9' tar -cJf"
alias gzz="tar -czf"
alias zst="tar -I 'zstd -19 -T4' -cf"
alias cdc="cd && cd Code"
alias tp="trash-put"

alias vi="nvim"
alias vim="nvim"
alias ac="aria2c"
alias ff="fastfetch"
alias mk="musikcube"
alias mg="mega-get" alias y="yazi"

alias jr="java"
alias jc="javac"
alias py="python"
alias dr="dotnet run"
alias dpl="dotnet publish -r linux-x64 --sc"
alias dpw="dotnet publish -r win-x64 --sc"
alias gcc="gcc -Wall"
alias g++="g++ -Wall"
alias cl="clang -std=c23 -Wall"
alias cl++="clang++ -std=c++23 -Wall"

alias sctl="systemctl"
alias sctls="systemctl status"
alias sctle="systemctl enable"
alias sctld="systemctl disable"
alias sctlr="systemctl restart"
alias pm="pacman"
alias se="sudoedit"

echo "Welocome, $USER!"
eval "$(starship init zsh)"
