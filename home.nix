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

  # Gtk and Qt Themes
  xdg.dataFile."themes/Dracula".source = inputs.dracula;

  xdg.configFile."Kvantum/Dracula/Dracula.kvconfig".source = "${inputs.dracula}/kde/kvantum/Dracula-purple-solid/Dracula-purple-solid.kvconfig";

  xdg.configFile."Kvantum/Dracula/Dracula.svg".source = "${inputs.dracula}/kde/kvantum/Dracula-purple-solid/Dracula-purple-solid.svg";

  xdg.configFile."Kvantum/kvantum.kvconfig".text = "[General]\ntheme=Dracula";

  xdg.configFile."lxqt".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.configurations/config/dracula/lxqt";

  xdg.configFile."gtk-3.0/settings.ini".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.configurations/config/dracula/gtk-3.0/settings.ini";

  xdg.configFile."fontconfig/fonts.conf".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.configurations/config/dracula/fontconfig/fonts.conf";

  # Awesome Window Manager (Will move to another file)
  xdg.configFile."awesome".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.configurations/config/awesome";

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
