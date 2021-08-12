{ inputs, pkgs, config, ... }:

{
  imports = [
    ./modules/dev/git.nix
    ./modules/desktop/bspwm.nix
    ./modules/desktop/sxhkd.nix
    ./modules/desktop/notification.nix
    ./modules/desktop/dracula.nix
    ./modules/desktop/polybar.nix
    ./modules/desktop/fonts.nix
    ./modules/desktop/terminal.nix
    ./modules/editors/emacs.nix
  ];

  home.packages = with pkgs; [
    neovim
    htop
    neofetch
    # Python
    (python3.withPackages (ps: with ps; [ requests ]))
    # Desktop
    ranger
    feh
    # Applets
    cbatticon
    gvolicon
    nm-tray
    # Applications
    libsForQt5.kdeconnect-kde
    neomutt
    mail-notification
    gnome.nautilus
    unstable.wezterm
    gnumake
  ];

  fonts.fontconfig.enable = true;
}
