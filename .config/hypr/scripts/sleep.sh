#swayidle -w timeout 300 'swaylock -f -c 000000' \
#            timeout 600 'hyprctl dispatch dpms off' \
#            timeout 900 'systemctl suspend' \
#            resume 'hyprctl dispatch dpms on' \
#            before-sleep 'swaylock -f -c 000000' &
#

image="$(grep "file" $HOME/.config/nitrogen/bg-saved.cfg | sed 's/file=//g')"

swayidle -w timeout 300 "swaylock -f -s fill -i $image" timeout 360 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on' before-sleep "swaylock -f -s fill -i $image" &
