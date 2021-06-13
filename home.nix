{ inputs, pkgs, config, ... }:

{
  imports = [ inputs.nix-doom-emacs.hmModule ];

  home.packages = with pkgs; [
    # Systray
    stalonetray
    # Preffered
    alacritty
    neovim
    htop
    ripgrep
    # Python
    (python3.withPackages (ps: with ps; [ requests ]))
    # Lua
    sumneko-lua-language-server
    # Nix
    nixfmt
    # Desktop
    dmenu
    rofi
    picom
    # K
    libsForQt5.kdeconnect-kde
    # QT theme
    libsForQt5.qtstyleplugin-kvantum
    # GTK theme
    papirus-icon-theme
    xdg-desktop-portal
    numix-icon-theme
    # Applets
    cbatticon
    gvolicon
    nm-tray
    # Applications
    neomutt
    mail-notification
  ];

  programs.doom-emacs = {
    enable = true;
    doomPrivateDir = ./config/doom.d;
  };

  services.emacs = {
    enable = true;
    package = config.programs.emacs.package;
  };

  programs.git = {
    enable = true;
    userName = "Aditya Sadawarte";
    userEmail = "adityasadawarte01@gmail.com";
  };
}
