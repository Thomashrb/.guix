(use-modules (gnu)
             (gnu packages shells)
             ;; Import nonfree linux module.
             (nongnu packages linux)
             (nongnu system linux-initrd))

(use-service-modules desktop networking ssh xorg docker)

(operating-system
  ;; Use nonfree firmware and drivers
  (kernel linux)
  (initrd microcode-initrd)
  (firmware (list linux-firmware))

  (locale "en_US.utf8")
  (timezone "Europe/Brussels")
  (keyboard-layout
    (keyboard-layout "no" "nodeadkeys"))
  (host-name "guix")
  (users (cons* (user-account
                  (name "bbsl")
                  (comment "Bbsl")
                  (shell #~(string-append #$zsh "/bin/zsh"))
                  (group "users")
                  (home-directory "/home/bbsl")
                  (supplementary-groups
                    '("wheel" "netdev" "audio" "video")))
                %base-user-accounts))
  (packages
    (append
      (list
            (specification->package "font-terminus")
            (specification->package "font-inconsolata")
            (specification->package "i3-wm")
            (specification->package "i3status")
            (specification->package "dmenu")
            (specification->package "rofi")
            (specification->package "bspwm")
            (specification->package "sxhkd")
            (specification->package "lxrandr")

            (specification->package "tmux")
            (specification->package "emacs")
            (specification->package "vim")

            (specification->package "zsh")
            (specification->package "zsh-autosuggestions")
            (specification->package "st")
            (specification->package "rxvt-unicode")
            (specification->package "xrdb")
            (specification->package "setxkbmap")

            (specification->package "tree")
            (specification->package "acpi")

            (specification->package "curl")
            (specification->package "wget")
            (specification->package "git")
            (specification->package "docker")
            (specification->package "docker-cli")
            (specification->package "flatpak")
            (specification->package "postgresql")
            (specification->package "elixir")

            (specification->package "lynx")
            (specification->package "firefox")
            (specification->package "nss-certs"))
      %base-packages))
  (services
    (append
      (list (service docker-service-type)
	    (service openssh-service-type)
            (set-xorg-configuration
              (xorg-configuration
                (keyboard-layout keyboard-layout))))
      %desktop-services))
  (bootloader
    (bootloader-configuration
      (bootloader grub-efi-bootloader)
      (target "/boot/efi")
      (keyboard-layout keyboard-layout)))
  (swap-devices (list "/dev/sda2"))
  (file-systems
    (cons* (file-system
             (mount-point "/boot/efi")
             (device (uuid "FADC-D519" 'fat32))
             (type "vfat"))
           (file-system
             (mount-point "/")
             (device
               (uuid "da1c3b89-23eb-4d5d-9f34-02f4a10550cd"
                     'ext4))
             (type "ext4"))
           %base-file-systems)))