;; Indicate which modules to import to access the variables
;; used in this configuration.
(use-modules (gnu) (gnu packages shells))
(use-service-modules cups desktop networking xorg sysctl)

(operating-system
  (locale "it_IT.utf8")
  (timezone "Europe/Berlin")
  (keyboard-layout (keyboard-layout "de"))
  (host-name "guix")
  (issue "Benvenuto! Questo e' il tuo sistema operativo!!!\n\n")
  (sudoers-file
    (plain-file "sudoers" "\
root ALL=(ALL) ALL
%wheel ALL=(ALL) ALL
"))
  (hosts-file
                  (plain-file "hosts" "\
127.0.0.1       localhost       guix
::1             localhost       guix
# Ads, tracking and general junk
"))

  ;; The list of user accounts ('root' is implicit).
  (users (cons* (user-account
                  (name "anonymous")
                  (comment "Anonymous")
                  (group "users")
                  (shell (file-append zsh "/bin/zsh"))
                  (home-directory "/home/anonymous")
                  (supplementary-groups '("wheel" "netdev" "audio" "video")))
                %base-user-accounts))

  ;; Packages installed system-wide.
  (packages (append (list (specification->package "bspwm")
                          (specification->package "sxhkd")
                          (specification->package "polkit-gnome")
                          (specification->package "libnma")
                          (specification->package "libmtp")
                          (specification->package "gvfs")
                          (specification->package "ntfs-3g")
                          (specification->package "tint2")
                          (specification->package "nitrogen")
                          (specification->package "feh")
                          (specification->package "dmenu")
                          (specification->package "xdotool")
                          (specification->package "xprop")
                          (specification->package "xinput")
                          (specification->package "xkill")
                          (specification->package "xsetroot")
                          (specification->package "xsel")
                          (specification->package "dmenu")
                          (specification->package "dunst")
                          (specification->package "picom")
                          (specification->package "i3lock")
                          (specification->package "lxappearance")
                          (specification->package "gsimplecal")
                          (specification->package "arc-theme")
                          (specification->package "arc-icon-theme")
                          (specification->package "breeze")
                          (specification->package "mousepad")
                          (specification->package "volumeicon")
                          (specification->package "font-dejavu")
                          (specification->package "font-bitstream-vera")
                          (specification->package "font-adobe-source-code-pro")
                          (specification->package "font-google-noto")
                          (specification->package "font-google-noto-emoji")
                          (specification->package "font-awesome")
                          (specification->package "icecat")
                          (specification->package "xterm")
                          (specification->package "most")
                          (specification->package "alacritty")
                          (specification->package "zsh")
                          (specification->package "zsh-autosuggestions")
                          (specification->package "zsh-syntax-highlighting")
                          (specification->package "vim")
                          (specification->package "vim-full")
                          (specification->package "vim-syntastic")
                          (specification->package "vim-airline")
                          (specification->package "vim-airline-themes")
                          (specification->package "neofetch")
                          (specification->package "htop")
                          (specification->package "bc")
                          (specification->package "bat")
                          (specification->package "exa")
                          (specification->package "ripgrep")
                          (specification->package "fzf")
                          (specification->package "cowsay")
                          (specification->package "cmatrix")
                          (specification->package "festival")
                          (specification->package "sl")
                          (specification->package "figlet")
                          (specification->package "lolcat")
                          (specification->package "daikichi")
                          (specification->package "fortunes-jkirchartz")
                          (specification->package "openssh")
                          (specification->package "curl")
                          (specification->package "git")
                          (specification->package "xrdb")
                          (specification->package "xdg-utils")
                          (specification->package "thunar")
                          (specification->package "thunar-archive-plugin")
                          (specification->package "thunar-volman")
                          (specification->package "zip")
                          (specification->package "unzip")
                          (specification->package "p7zip")
                          (specification->package "unrar-free")
                          (specification->package "xarchiver")
                          (specification->package "ranger")
                          (specification->package "neomutt")
                          (specification->package "newsboat")
                          (specification->package "zathura")
                          (specification->package "zathura-pdf-mupdf")
                          (specification->package "sxiv")
                          (specification->package "mpv")
                          (specification->package "ffmpeg")
                          (specification->package "tumbler")
                          (specification->package "ffmpegthumbnailer")
                          (specification->package "scrot")
                          (specification->package "mpd")
                          (specification->package "mpc")
                          (specification->package "ncmpcpp")
                          (specification->package "youtube-dl")
                          (specification->package "yt-dlp")
                          (specification->package "redshift")
                          (specification->package "gnome-mines")
                          (specification->package "quadrapassel")
                          (specification->package "aisleriot")
                          (specification->package "gimp")
                          (specification->package "shotcut")
                          (specification->package "libreoffice")
                          (specification->package "telegram-desktop")
                          (specification->package "qemu")
                          (specification->package "system-config-printer")
                          (specification->package "simple-scan")
                          (specification->package "nss-mdns")
                          (specification->package "iptables")
                          (specification->package "dnscrypt-proxy")
                          (specification->package "nss-certs"))
                    %base-packages))

  ;; Below is the list of system services.  To search for available
  ;; services, run 'guix system search KEYWORD' in a terminal.
  (services
    (cons* (service cups-service-type)
           (service iptables-service-type
             (iptables-configuration
               (ipv4-rules (plain-file "iptables.rules" "*filter
:INPUT DROP
:FORWARD DROP
:OUTPUT ACCEPT
-A INPUT -i lo -j ACCEPT
-A OUTPUT -o lo -j ACCEPT
-A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
-A INPUT -j REJECT --reject-with icmp-port-unreachable
COMMIT
"))
               (ipv6-rules (plain-file "ip6tables.rules" "*filter
:INPUT DROP
:FORWARD DROP
:OUTPUT ACCEPT
-A INPUT -i lo -j ACCEPT
-A OUTPUT -o lo -j ACCEPT
-A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
-A INPUT -j REJECT --reject-with icmp6-port-unreachable
COMMIT
"))))
	   (service slim-service-type
		    (slim-configuration
		      (xorg-configuration
			(xorg-configuration (keyboard-layout keyboard-layout)))
		      (auto-login? #t)
		      (default-user "anonymous")))
	   (modify-services %desktop-services
                            (login-service-type config =>
                               (login-configuration
		                  (motd (plain-file "motd" "\
Ciao dal tuo sistema operativo!!!\n\n"))))
			    (sysctl-service-type config =>
						 (sysctl-configuration
						   (settings (append '(("vm.swappiness" . "10"))
								     %default-sysctl-settings))))
			    (delete gdm-service-type))))

  (bootloader (bootloader-configuration
                (bootloader grub-bootloader)
                (targets (list "/dev/sda"))
                (menu-entries (list (menu-entry
                                      (label "Parabola")
                                      (linux "(ahci0,msdos2)/boot/vmlinuz-linux-libre")
                                      (linux-arguments '("root=/dev/sda2 rw  l1tf=full,force mds=full,nosmt mitigations=auto,nosmt nosmt=force quiet loglevel=3"))
                                      (initrd "(ahci0,msdos2)/boot/initramfs-linux-libre.img"))))
                (keyboard-layout keyboard-layout)))

  (kernel-arguments (list "l1tf=full,force mds=full,nosmt mitigations=auto,nosmt nosmt=force modprobe.blacklist=usbmouse,usbkbd quiet loglevel=3"))

  (swap-devices (list (swap-space
                          ; change UUID... blkid
                        (target (uuid
                                 "b7085fba-fa95-43bf-8d0a-8c7e93be32e9")))))
  (mapped-devices (list (mapped-device
                          ; change UUID... blkid
                          (source (uuid
                                   "1b62df79-eb8b-4260-a869-cbb1425394ae"))
                          (target "home")
                          (type luks-device-mapping))))

  ;; The list of file systems that get "mounted".  The unique
  ;; file system identifiers there ("UUIDs") can be obtained
  ;; by running 'blkid' in a terminal.
  (file-systems (cons* (file-system
                         (mount-point "/home")
                         (device "/dev/mapper/home")
                         (type "ext4")
			 (flags '(no-atime no-suid no-dev))
                         (dependencies mapped-devices))
                       (file-system
                         (mount-point "/")
                          ; change UUID... blkid
                         (device (uuid
                                  "b396f334-4fb5-4ed3-a448-29d94dedfbe9"
                                  'ext4))
                         (type "ext4")
			 (flags '(no-atime)))
		       %base-file-systems)))
