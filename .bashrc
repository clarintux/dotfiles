# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Source fzf...
[ -f /usr/share/fzf/key-bindings.bash ] && source /usr/share/fzf/key-bindings.bash
[ -f /usr/share/fzf/completion.bash ] && source /usr/share/fzf/completion.bash

PS1="\[\033[01;33m\]\u\[\033[01;36m\]@\[\033[01;31m\]\h\[\033[00m\]\[\033[01;34m\]\w\[\033[00m\]\$ "

[ -d "$HOME/.local/bin" ] && PATH="$HOME/.local/bin:$PATH"
PATH=$HOME/.local/bin:$PATH

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

distro=$(grep -e "^ID=" /etc/os-release | cut -d '=' -f2)
case $distro in
    arch|parabola) alias update='sudo pacman -Syyu' ;
        alias clean='sudo pacman -Rns $(pacman -Qtdq)' ;;
    debian|ubuntu|trisquel) alias update='sudo apt update && sudo apt upgrade' ;
        alias clean='sudo apt --purge autoremove && sudo apt clean && sudo apt autoclean' ;;
    guix) alias update='guix pull && sudo guix system reconfigure /etc/config.scm' ;
        alias fortune='daikichi fortune' ;;
esac

alias pac='sudo pacman'
alias cmatrix='cmatrix -C cyan -s'
alias meteo='curl https://wttr.in/Frankfurt?qFm'
alias op='xdg-open "$(fzf)"'
alias news='torsocks newsboat -q 2>/dev/null'
alias ip_addres='wget -qO- http://ipecho.net/plain && echo'
alias youtube-music='torsocks youtube-dl --extract-audio --audio-format mp3'
alias PP='pipes2-slim'
alias config='git --git-dir=$HOME/.cfg/ --work-tree=$HOME' # bar repo

### Preventing nested ranger instances
ranger() {
    if [ -z "$RANGER_LEVEL" ]; then
        ranger "$@"
    else
        exit
    fi
}

### ARCHIVE EXTRACTION
# usage: ex 
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
        echo "Usage: countdown "
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
        torsocks curl https://cheat.sh/$1
    else
        echo "Usage: cheat "
    fi
}

### corona
corona ()
{
    if [ -n "$1" ] ; then
        torsocks curl https://corona-stats.online/$1
    else
        torsocks curl https://corona-stats.online?top=25
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
            1) fortune | cowsay -f "${COW[$(( $RANDOM % 3))]}" | lolcat 2>/dev/null ;;
            2) figlet "Ciao Luigi !" | lolcat 2>/dev/null ;;
        esac
    fi
}

# ripgrep + fzf: Select file with with occurence of  and open it
rip ()
{
    if [ -n "$1" ] ; then
        rg "$1" . | fzf -m | awk -F':' '{print $1}' | xargs -ro xdg-open
    else
        echo "Usage: rip "
    fi
}

term_greeting
