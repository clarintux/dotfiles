#!/bin/sh

if [ "$(id -u)" = 0 ]; then
    echo
    echo "##################################################################"
    echo "NON ESEGUIRE QUESTO SCRIPT CON SUDO O PRIVILEGI DI ROOT !!!"
    echo "Eseguilo come normale utente. Ti verra' chiesto di inserire"
    echo "la password sudo solo quando necessario."
    echo "##################################################################"
    echo
    exit 1
fi

echo
echo "Benvenuto nello script per installare ClarintuxOS!"
echo
echo "Si tratta di uno script post-installazione per"
echo "distribuzioni Arch-based che copia i miei dotfiles"
echo "ed installa i pacchetti presenti sul mio sistema."
echo "Per alcuni comandi verra' chiesto di inserire la"
echo "password sudo. Saluti dal vostro Clarintux!"
echo
echo "P.S.: Questo script e la risultante distribuzione"
echo "      sono distribuiti assolutamente senza garanzia!"
echo "      Eseguilo a tuo rischio e pericolo, senza"
echo "      aspettarti supporto tecnico da me!"
echo
read -p "Vuoi proseguire? (S/n) " choice


if [ "$choice" != "S" ] && [ "$choice" != "s" ]; then
    exit 1
fi


echo
read -p "Installo curl e git...[Premi INVIO]"
sudo pacman --noconfirm --needed -Sy curl git
echo


echo "Faccio un backup su '.config-backup' dell'intera directory"
read -p "'.config' e dei dotfiles presenti sulla home... [Premi INVIO]"
mkdir -p ~/.config-backup
cp -r ~/.config ~/.config-backup
cp -r ~/.local ~/.config-backup
ls -pa | \grep --color=auto -E -v /$ | \grep --color=auto "^\." | xargs -I{} cp {} ~/.config-backup
echo


echo "Fatto! Clono il repository https://github.com/clarintux/dotfiles"
read -p "ed installo i dotfiles...[Premi INVIO]"
git clone --bare https://github.com/clarintux/dotfiles.git $HOME/.cfg
function config {
   /usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME $@
}
config checkout
if [ $? = 0 ]; then
    echo
    echo "Dotfiles installati con successo!"
else
    echo
    echo "ATTENZIONE:Devo cancellare dotfiles preesistenti. Controlla se"
    echo "hai un backup sulla directory '.config-backup' appena creata."
    read -p "Procedo? (S/n) " choice
    if [ "$choice" = "S" ] || [ "$choice" = "s" ]; then
        config checkout 2>&1 | grep -E "\s+\." | awk {'print $1'} | xargs -I{} rm {}
    	rm README.md LICENSE config.scm
    else
        exit 1
    fi
fi
config checkout
config config status.showUntrackedFiles no

rm README.md LICENSE config.scm
echo
echo "OK...dotfiles installati con successo!"
read -p "Ora installo i pacchetti di ClarintuxOS [Premi INVIO]"
sudo pacman --noconfirm --needed -Sy - < ~/.local/share/misc/packages.txt


echo
read -p "Clono wallpapers e li salvo su \$HOME/Immagini/wallpapers [Premi INVIO]"
mkdir -p ~/Immagini
git clone https://github.com/clarintux/wallpapers.git ~/Immagini/wallpapers

echo
echo "Inserisci il codice del layout della tastiera."
echo "Esempio: it per italiano, us per inglese,"
echo "de per tedesco, eccetera."
read -p "Codice: " code
sed -i "s/kb_layout = de/kb_layout = $code/g" ~/.config/hypr/hyprland.conf
sed -i "s/setxkbmap de/setxkbmap $code/g" ~/.config/bspwm/bspwmrc ~/.config/openbox/autostart

choice="T"
while [ "$choice" != "W" ] && [ "$choice" != "C" ] && [ "$choice" != "A" ]
do
    echo
    echo "Inserisci il tasto modificatore (W=SUPER, C=CTRL, A=ALT)."
    read -p "(W / C / A): " choice
done

case "$choice" in
    "C") sed -i 's/W-/C-/g' ~/.config/openbox/rc.xml ;
            sed -i 's/super/ctrl/g' ~/.config/sxhkd/sxhkdrc ;
            sed -i 's/mainMod = SUPER/mainMod = CTRL/g' ~/.config/hypr/hyprland.conf ;;
    "A") sed -i 's/W-/A-/g' ~/.config/openbox/rc.xml ;
            sed -i 's/super/alt/g' ~/.config/sxhkd/sxhkdrc ;
            sed -i 's/mainMod = SUPER/mainMod = ALT/g' ~/.config/hypr/hyprland.conf ;;
esac


echo
echo "Vuoi usare zsh come shell predefinita"
read -p "per il tuo utente? (S/n) " choice
if [ "$choice" = "S" ] || [ "$choice" = "s" ]; then
    chsh -s /bin/zsh
fi


choice=0
while [ "$choice" != "1" ] && [ "$choice" != "2" ] && [ "$choice" != "3" ]
do
    echo
    echo "Scegli il Window Manager o compositor Wayland predefinito:"
    echo "  1) Hyprland (Wayland)"
    echo "  2) BSPWM (Xorg)"
    echo "  3) Openbox (Xorg)"
    read -p "Fai la tua scelta: " choice
done

case "$choice" in
    1) sed -i 's/.*#dbus-run-session Hyprland/    dbus-run-session Hyprland/g;s/.*exec startx/    #exec startx/g' ~/.bash_profile ~/.zprofile;;
    2) sed -i 's/^#exec bspwm/exec bspwm/g;s/^exec openbox-session/#exec openbox-session/g' ~/.xinitrc;
        sed -i 's/.*dbus-run-session Hyprland/    #dbus-run-session Hyprland/g;s/.*#exec startx/    exec startx/g' ~/.bash_profile ~/.zprofile;
        ln -sf ~/.config/tint2/tint2rc_bspwm ~/.config/tint2/tint2rc;;
    3) sed -i 's/^#exec openbox-session/exec openbox-session/g;s/^exec bspwm/#exec bspwm/g' ~/.xinitrc;
        sed -i 's/.*dbus-run-session Hyprland/    #dbus-run-session Hyprland/g;s/.*#exec startx/    exec startx/g' ~/.bash_profile ~/.zprofile;
        ln -sf ~/.config/tint2/tint2rc_openbox ~/.config/tint2/tint2rc;;
esac

chmod +x ~/.local/bin/*

echo
echo "Ho finito! Riavvia e il gioco e' fatto..."
echo "Non dimenticare di installare Tor Browser e torsocks!!!"
echo "E di adattare eventualmente configurazioni, come"
echo ".config/mpd/mpd.conf , .config/ncmpcpp/config ,"
echo ".confif/neomutt/neomuttrc, .config/newsboat/urls ,"
echo ".confif/neomutt/neomuttrc, .config/newsboat/urls ,"
echo "eccetera. Buon divertimento!"
echo
