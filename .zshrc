# If not running interactively, don't do anything
[[ $- != *i* ]] && return 

[ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh
[ -f /usr/share/fzf/completion.zsh ] && source /usr/share/fzf/completion.zsh

autoload -U colors && colors	# Load colors

PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "

[ -d $HOME/.local/bin ] && PATH=$HOME/.local/bin:$PATH

setopt APPEND_HISTORY
setopt SHARE_HISTORY
HISTFILE=~/.local/share/zhistory
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_EXPIRE_DUPS_FIRST
setopt EXTENDED_HISTORY

# autocompletion using arrow keys (based on history)
bindkey '\e[A' history-search-backward
bindkey '\e[B' history-search-forward

## Options section
setopt correct                                                  # Auto correct mistakes
setopt extendedglob                                             # Extended globbing. Allows using regular expressions with *
setopt nocaseglob                                               # Case insensitive globbing
setopt rcexpandparam                                            # Array expension with parameters
setopt nocheckjobs                                              # Don't warn about running processes when exiting
setopt numericglobsort                                          # Sort filenames numerically when it makes sense
setopt nobeep                                                   # No beep
setopt appendhistory                                            # Immediately append history instead of overwriting
setopt histignorealldups                                        # If a new command is a duplicate, remove the older one
setopt autocd                                                   # if only directory path is entered, cd there.
setopt inc_append_history                                       # save commands are added to the history immediately, otherwise only when shell exits.
setopt histignorespace                                          # Don't save commands that start with space

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'       # Case insensitive tab completion
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"         # Colored completion (different colors for dirs/files/etc)
zstyle ':completion:*' rehash true                              # automatically find new executables in path
# Speed up completions
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
setopt interactive_comments
bindkey -e
zstyle :compinstall filename "$HOME/.zshrc"
WORDCHARS=${WORDCHARS//\/[&.;]}                                 # Don't consider certain characters part of the word

autoload -Uz compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

### ABBREVETIONS LIKE FISH...
# declare a list of expandable aliases to fill up later
typeset -a ealiases
ealiases=()

# write a function for adding an alias to the list mentioned above
function abbrev-alias() {
    alias $1
    ealiases+=(${1%%\=*})
}

# expand any aliases in the current line buffer
function expand-ealias() {
    if [[ $LBUFFER =~ "\<(${(j:|:)ealiases})\$" ]]; then
        zle _expand_alias
        zle expand-word
    fi
    zle magic-space
}
zle -N expand-ealias

# Bind the space key to the expand-alias function above, so that space will expand any expandable aliases
bindkey ' '        expand-ealias
bindkey '^ '       magic-space     # control-space to bypass completion
bindkey -M isearch " "      magic-space     # normal space during searches

# A function for expanding any aliases before accepting the line as is and executing the entered command
expand-alias-and-accept-line() {
    expand-ealias
    zle .backward-delete-char
    zle .accept-line
}
zle -N accept-line expand-alias-and-accept-line

alias config='git --git-dir=$HOME/.cfg/ --work-tree=$HOME' # bar repo
alias open='xdg-open "$(fzf)"'
alias vi='vim'
abbrev-alias ..='cd ..'
abbrev-alias ls='exa -G --color auto'
abbrev-alias ll='exa -l -a -G --color always'
abbrev-alias grep='grep --color=auto'
abbrev-alias fgrep='fgrep --color=auto'
abbrev-alias egrep='egrep --color=auto'
abbrev-alias diff='diff --color=auto'
abbrev-alias ip='ip -color=auto'
abbrev-alias mkdir='mkdir -pv'
abbrev-alias cp='cp -iv'
abbrev-alias mv='mv -iv'
abbrev-alias rm='rm -Iv'
abbrev-alias cat='bat --italic-text=always --color=auto --theme=gruvbox-dark -Pp'
abbrev-alias less='bat --italic-text=always --color=auto --theme=gruvbox-dark -n'
abbrev-alias SS='sudo systemctl'
distro=$(grep -e "^ID=" /etc/os-release | cut -d '=' -f2)
case $distro in
    arch|parabola) alias update='sudo pacman -Syyu' ;
        alias clean='sudo pacman -Rns $(pacman -Qtdq)' ;;
    debian|ubuntu|trisquel) alias update='sudo apt update && sudo apt upgrade' ;
        alias clean='sudo apt --purge autoremove && sudo apt clean && sudo apt autoclean' ;;
    guix) alias update='guix pull && sudo guix system reconfigure /etc/config.scm' ;
        alias fortune='daikichi fortune' ;;
esac
abbrev-alias pac='sudo pacman'
abbrev-alias cmatrix='cmatrix -C cyan -s'
abbrev-alias meteo='curl "https://wttr.in/Frankfurt?qFm"'
abbrev-alias news='torsocks newsboat -q 2>/dev/null'
abbrev-alias ip_addres='wget -qO- http://ipecho.net/plain && echo'
abbrev-alias youtube-music='torsocks youtube-dl --extract-audio --audio-format mp3'
abbrev-alias PP='pipes2-slim'


#### Preventing nested ranger instances
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

### cheat
cheat ()
{
    if [ -n "$1" ] ; then
        torsocks curl https://cheat.sh/$1
    else
        echo "Usage: cheat "
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
            1) fortune | cowsay -f "${COW[$(( $RANDOM % 3 + 1))]}" | lolcat 2>/dev/null ;;
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

# Load syntax highlighting; should be last.
[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ] && source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

term_greeting
