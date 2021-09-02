{ inputs, pkgs, config, ... }:

{
  # Yes home.nix, your refactoring time will arrive soon
  imports = [
    # home manager
    ../hm-modules/qtile.nix

    # my
    ../modules/dev/git.nix
    #../modules/desktop/xmonad.nix
    ../modules/desktop/qtile.nix
    #../modules/desktop/sxhkd.nix
    ../modules/desktop/notification.nix
    ../modules/desktop/dracula.nix
    ../modules/desktop/polybar.nix
    ../modules/desktop/fonts.nix
    ../modules/desktop/terminal.nix
    ../modules/editors/emacs.nix
    ../modules/editors/neovim.nix
  ];

  nixpkgs.overlays = [
    (final: prev: { unstable = inputs.nixpkgs-unstable.legacyPackages.${prev.system}; })
  ];

  # broken packages
  nixpkgs.config.allowBroken = false;

  home.packages = with pkgs; [
    htop
    neofetch
    # in case on no wm keybindings
    xorg.xkill
    # Python
    #(python3.withPackages (ps: with ps; [ requests ]))
    # Desktop
    feh
    # Applets
    cbatticon
    gvolicon
    nm-tray
    # Applications
    libsForQt5.kdeconnect-kde
    neomutt
    mail-notification
    pcmanfm
    qtile
  ];

  fonts.fontconfig.enable = true;
}
