# _          _       _                               __ _ _      
# | |   _   _(_) __ _(_)___      _____ __  _ __ ___  / _(_) | ___ 
# | |  | | | | |/ _` | / __|    |_  / '_ \| '__/ _ \| |_| | |/ _ \
# | |__| |_| | | (_| | \__ \   _ / /| |_) | | | (_) |  _| | |  __/
# |_____\__,_|_|\__, |_|___/  (_)___| .__/|_|  \___/|_| |_|_|\___|
#               |___/               |_|                           
# 
# Profile file. Runs on login.

[[ -f ~/.zshrc ]] && . ~/.zshrc

# ~/ Clean-up:
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export GTK2_RC_FILES="${XDG_CONFIG_HOME:-$HOME/.config}/gtk-2.0/gtkrc-2.0"
export LESSHISTFILE="-"
export WGETRC="${XDG_CONFIG_HOME:-$HOME/.config}/wget/wgetrc"
export KODI_DATA="${XDG_DATA_HOME:-$HOME/.local/share}/kodi"
export TMUX_TMPDIR="$XDG_RUNTIME_DIR"
export ANDROID_SDK_HOME="${XDG_CONFIG_HOME:-$HOME/.config}/android"
#export XINITRC="${XDG_CONFIG_HOME:-$HOME/.config}/x11/xinitrc"
export XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority" # This line will break some DMs.
export HISTFILE="${XDG_DATA_HOME:-$HOME/.local/share}/zhistory"

export PERL_DESTRUCT_LEVEL=2 # solve urxvt problem
export LANG='it_IT.UTF-8'
export VISUAL=vim
export EDITOR=vim
export TERMINAL=alacritty
export BROWSER=iceweasel
export READER=zathura
export VIDEO=mpv
export IMAGE=sxiv
export FILE=ranger
export FILE_VISUAL=thunar
export WM=bspwm
export STARDICT_DATA_DIR="$HOME/.local/share"
export QT_QPA_PLATFORMTHEME="gtk2"  # Have QT use gtk2 theme.
export MOZ_USE_XINPUT2="1"  # Mozilla smooth scrolling/touchpads.
export pacdiff_program="vimdiff" # for pacmatic
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
export LESS=-R
export LESS_TERMCAP_mb=$'\E[1;31m'     # begin blink
export LESS_TERMCAP_md=$'\E[1;36m'     # begin bold
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[01;44;33m' # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

# MPD daemon start (if no other user instance exists)
[ ! -s ~/.config/mpd/pid ] && mpd &> /dev/null
#[ ! -s ~/.config/mpd/pid ] && mpd

# Start graphical server if not already running.
if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
  exec startx -- vt1 &> /dev/null
fi
