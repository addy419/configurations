{ inputs, pkgs, config, ... }:

{
  home.packages = with pkgs; [
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
    ranger
    picom
    # Themes
    lxqt.lxqt-config
    lxqt.lxqt-qtplugin
    libsForQt5.qtstyleplugin-kvantum
    xdg-desktop-portal
    glib
    xsettingsd
    papirus-icon-theme
    # Fonts
    roboto
    # Applets
    cbatticon
    gvolicon
    nm-tray
    # Applications
    libsForQt5.kdeconnect-kde
    neomutt
    mail-notification
    emacs
  ];

  xdg.enable = true;

  #xdg.configFile."lxqt" = {
  #  source = config.lib.file.mkOutOfStoreSymlink ./config/dracula/lxqt;
  #  recursive = true;
  #};

  xdg.dataFile."themes/Dracula" = {
    source = inputs.dracula;
  };

  xdg.configFile."lxqt" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.configurations/config/dracula/lxqt";
  };

  home.file.".config/gtk-3.0/settings.ini" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.configurations/config/dracula/gtk-3.0/settings.ini";
  };

  services.emacs = {
    enable = true;
    package = pkgs.emacs;
  };

  programs.git = {
    enable = true;
    userName = "Aditya Sadawarte";
    userEmail = "adityasadawarte01@gmail.com";
  };
}
