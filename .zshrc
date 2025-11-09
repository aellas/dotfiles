
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="minimal"

setopt globdots
setopt EXTENDED_GLOB

autoload -Uz compinit
if [ "$(date +'%j')" != "$(stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null)" ]; then
    compinit
else
    compinit -C
fi

plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-bat
)

ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_USE_ASYNC=1

lua "$HOME/Documents/lufetch/lufetch.lua"

source $ZSH/oh-my-zsh.sh

export PATH="$HOME/.config/emacs/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin/:$PATH"

export EDITOR="emacs"

eval "$(zoxide init zsh)"

alias em="emacs"
alias rem="killall emacs || echo 'Emacs server not running'; /usr/bin/emacs --daemon"
alias dsync="doom sync && pkill emacs && emacsclient -c -a 'emacs' &"

alias cd="z"
alias dots="z ~/dotfiles"
alias cat="bat"


alias update="sudo dnf update"
alias upgrade="sudo dnf upgrade --refresh"

alias ls='eza -A --color=always --group-directories-first --icons'
alias ll='eza -Ahl --color=always --group-directories-first --icons'
alias lt='eza -aT --color=always --group-directories-first'
alias jctl="journalctl -p 3 -xb"

alias sync="rsync -avh dotfiles /home/array/Documents/ array@sernix:/mnt/backup/dots"
# ssh
alias pixelssh="ssh u0_a555@100.76.21.64 -p8022"
alias sernix="ssh array@sernix"

