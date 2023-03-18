#  _          _       _               _       _ _            
# | |   _   _(_) __ _(_)___     __  _(_)_ __ (_) |_ _ __ ___ 
# | |  | | | | |/ _` | / __|    \ \/ / | '_ \| | __| '__/ __|
# | |__| |_| | | (_| | \__ \   _ >  <| | | | | | |_| | | (__ 
# |_____\__,_|_|\__, |_|___/  (_)_/\_\_|_| |_|_|\__|_|  \___|
#               |___/                                        
# 
# Run with startx.

# Load resource file. Do not background the xrdb command, otherwise programs launched after xrdb may look for resources too early 
#[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources

# Keyboard layout
#setxkbmap de &

#xinput set-prop 10 "libinput Tapping Enabled" 1

# Compositor
#picom -b -c -f &

# Wallpaper
#nitrogen --restore &

# notify-send...
#/usr/lib/notification-daemon-1.0/notification-daemon &
#dunst &

#xscreensaver -no-splash &

# Start WM
#exec openbox-session
exec bspwm
#exec jwm
#exec startxfce4
