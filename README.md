# Clarintux's Dotfiles

This repository contains my personal dotfiles.

- OS: GNU/Linux
- Shell: bash, zsh
- Terminal: alacritty, xterm
- Window Manager: BSPWM, jwm, openbox
- File Manager: ranger, thunar
- Editor: vim
- Notification: Dunst
- Client Email: neomutt
- Other: dmenu, scripts, tint2

I'm an average Linu user and not an expert...!
--------------------------------
To install my setup:
```
sudo pacman -S curl git
curl https://raw.githubusercontent.com/clarintux/dotfiles/master/.local/bin/install_dotfiles.sh | sh
sudo pacman -S --needed - < $HOME/.local/share/misc/packages.txt
```
(For me...) To push:
```
config status
config add .vimrc
config commit -m "Add vimrc"
config add .bashrc
config commit -m "Add bashrc"
config push
```
