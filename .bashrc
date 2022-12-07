#   _        _      _      ___          _           
#  | |  _  _(_)__ _(_)___ | _ ) __ _ __| |_  _ _ __ 
#  | |_| || | / _` | (_-< | _ \/ _` (_-< ' \| '_/ _|
#  |____\_,_|_\__, |_/__/ |___/\__,_/__/_||_|_| \__|
#             |___/                                 
#
# My bash config

[[ $- != *i* ]] && return # If not interactively, don't do anything

[ -f /usr/share/fzf/key-bindings.bash ] && source /usr/share/fzf/key-bindings.bash
[ -f /usr/share/fzf/completion.bash ] && source /usr/share/fzf/completion.bash

export PATH=$PATH:$HOME/.local/bin

PS1="\[\033[01;33m\]\u\[\033[01;36m\]@\[\033[01;31m\]\h\[\033[00m\]\[\033[01;34m\]\w\[\033[00m\]\$ "

if [ -n "$RANGER_LEVEL" ]; then export PS1="\[\033[01;36m\][ranger] $PS1"; fi

HISTCONTROL=ignoreboth # no duplicats or lines starting with space
HISTSIZE=10000
HISTFILESIZE=10000

stty -ixon # Disable ctrl-s and ctrl-q

shopt -s histappend # append to history file, don't overwrite it
shopt -s autocd # change directory without "cd"
shopt -s cdspell # autocorrects cd misspellings
shopt -s checkwinsize # checks term size when bash regains control
shopt -s cmdhist # save multi-line commands as single line
shopt -s dotglob
shopt -s expand_aliases # expand aliases

bind "set completion-ignore-case on" # ignore upper and lowercase when TAB completion

### ALIASES ###
alias ..='cd ..'
alias ls='exa -G --color auto'
alias ll='exa -l -a -G --color always'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias diff='diff --color=auto'
alias ip='ip -color=auto'
alias mkdir='mkdir -pv'
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -Iv'
alias cat='bat --italic-text=always --color=auto --theme=gruvbox-dark -Pp'
alias less='bat --italic-text=always --color=auto --theme=gruvbox-dark -n'
alias SS='sudo systemctl'
distro=$( grep -e "arch" /etc/os-release )
if [ -n "$distro" ]; then
    alias update='sudo pacmatic -Syyu'
    alias clean='sudo pacman -Rns $(pacman -Qtdq)'
else
    alias update='sudo apt update && sudo apt upgrade'
    alias clean='sudo apt --purge autoremove && sudo apt clean && sudo apt autoclean'
fi
alias pac='sudo pacman'
alias cmatrix='cmatrix -C cyan -s'
alias meteo='curl https://wttr.in/Frankfurt?qFm'
alias op='xdg-open "$(fzf)"'
alias news='newsboat -q 2>/dev/null'
alias indirizzo='wget -qO- http://ipecho.net/plain && echo'
alias youtube-music='youtube-dl --extract-audio --audio-format mp3'
alias PP='pipes2-slim'
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

### Preventing nested ranger instances
ranger() {
    if [ -z "$RANGER_LEVEL" ]; then
        /usr/bin/ranger "$@"
    else
        exit
    fi
}

### ARCHIVE EXTRACTION
# usage: ex <file>
ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1   ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *.deb)       ar x $1      ;;
      *.tar.xz)    tar xf $1    ;;
      *.tar.zst)   unzstd $1    ;;      
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

### Fuzzy find and edit (or sudoedit)
edi ()
{
    if [ -n "$1" ]; then
        find $1 -type f 2>/dev/null | fzf | xargs -o sudoedit
    else
        find $HOME -type f | fzf | xargs -o $EDITOR
    fi
}

### COUNTDOWN
countdown ()
{
    if [ -n "$1" ] ; then
        N=$1
        echo -en "\033[2J\033[;H"
        echo "$N" | figlet -c && sleep 1
        while [[ $((--N)) > 0 ]]
            do
                echo -en "\033[2J\033[;H"
                echo "$N" | figlet -c && sleep 1
            done
        mpv /usr/share/sounds/freedesktop/stereo/complete.oga &>/dev/null &
    else
        echo "Usage: countdown <seconds>"
    fi
}

### SHOW DATE
show_date ()
{
    while true
        do
            printf '%s\r' "$(date)"
        done
}

### cheat
cheat ()
{
    if [ -n "$1" ] ; then
        curl https://cheat.sh/$1
    else
        echo "Usage: cheat <command>"
    fi
}

### corona
corona ()
{
    if [ -n "$1" ] ; then
        curl https://corona-stats.online/$1
    else
        curl https://corona-stats.online?top=25
    fi
}

### execute random command
term_greeting ()
{
    N=$(( $RANDOM % 3))

    if [ "$COLUMNS" -ge "98" ] ; then
        case $N in
            0) pacmanw ;;
            1) space-invaders ;;
            2) tux ;;
        esac
    else
        COW=( "default" "eyes" "tux" )
        case $N in
            0) neofetch ;;
            1) fortune | cowsay -f "${COW[$(( $RANDOM % 3))]}" | lolcat ;;
            2) figlet "Ciao Luigi !" | lolcat ;;
        esac
    fi
}

# ripgrep + fzf: Select file with with occurence of <string> and open it
rip ()
{
    if [ -n "$1" ] ; then
        rg "$1" . | fzf -m | awk -F':' '{print $1}' | xargs -ro xdg-open
    else
        echo "Usage: rip <search string>"
    fi
}

term_greeting
