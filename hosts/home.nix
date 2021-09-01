{ inputs, pkgs, config, lib, ... }:

{
  imports = [
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
  ];

  fonts.fontconfig.enable = true;

  xsession = {
    enable = true;
    windowManager.qtile = {
      enable = true;
      keybindings = {
        "mod + mod1 + r" = "lazy.restart()";
        "mod + control + j" = "lazy.layout.shrink()";
        "mod + control + k" = "lazy.layout.grow()";
      };
      groups = (lib.genList (i: toString(i + 1)) 9);
      layouts = [ "MonadTall()" ];
    };
  };

  home.stateVersion = "21.05";
}
