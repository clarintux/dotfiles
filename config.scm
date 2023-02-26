;; Indicate which modules to import to access the variables
;; used in this configuration.
(use-modules (gnu))
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
                  (home-directory "/home/anonymous")
                  (supplementary-groups '("wheel" "netdev" "audio" "video")))
                %base-user-accounts))

  ;; Packages installed system-wide.
  (packages (append (list (specification->package "bspwm")
                          (specification->package "sxhkd")
                          (specification->package "tint2")
                          (specification->package "nitrogen")
                          (specification->package "dmenu")
                          (specification->package "dunst")
                          (specification->package "picom")
                          (specification->package "lxappearance")
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
                          (specification->package "alacritty")
                          (specification->package "zsh")
                          (specification->package "zsh-autosuggestions")
                          (specification->package "zsh-syntax-highlighting")
                          (specification->package "vim")
                          (specification->package "vim-airline-themes")
                          (specification->package "neofetch")
                          (specification->package "htop")
                          (specification->package "openssh")
                          (specification->package "curl")
                          (specification->package "git")
                          (specification->package "xrdb")
                          (specification->package "thunar")
                          (specification->package "ranger")
                          (specification->package "neomutt")
                          (specification->package "newsboat")
                          (specification->package "zathura")
                          (specification->package "sxiv")
                          (specification->package "mpv")
                          (specification->package "scrot")
                          (specification->package "mpd")
                          (specification->package "mpc")
                          (specification->package "ncmpcpp")
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
           (service login-service-type
		    (login-configuration
		      (motd (plain-file "motd" "\
Ciao dal tuo sistema operativo!!!\n\n"))))
	   (service slim-service-type
		    (slim-configuration
		      (xorg-configuration
			(xorg-configuration (keyboard-layout keyboard-layout)))
		      (auto-login? #t)
		      (default-user "anonymous")))
	   (modify-services %desktop-services
			    (sysctl-service-type config =>
						 (sysctl-configuration
						   (settings (append '(("vm.swappiness" . "10"))
								     %default-sysctl-settings))))
			    (delete gdm-service-type))))

  (bootloader (bootloader-configuration
                (bootloader grub-bootloader)
                (targets (list "/dev/sda"))
                (keyboard-layout keyboard-layout)))

  (kernel-arguments (list "l1tf=full,force mds=full,nosmt mitigations=auto,nosmt nosmt=force modprobe.blacklist=usbmouse,usbkbd quiet loglevel=3"))

  (swap-devices (list (swap-space
                        (target (uuid
                                 "ebba7404-6956-41dc-9003-c02967e4eee7")))))
  (mapped-devices (list (mapped-device
                          (source (uuid
                                   "b98f99e1-0760-458d-a7e7-6a6c01f562e9"))
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
                         (device (uuid
                                  "81efaef5-e3ed-43b2-863b-0fe463b9a175"
                                  'ext4))
                         (type "ext4")
			 (flags '(no-atime)))
		       %base-file-systems)))
