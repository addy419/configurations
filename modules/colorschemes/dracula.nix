{ lib, config, inputs, pkgs, ... }:
with lib;

let
  cfg = config.colorscheme.dracula;
  dracula-gtk = pkgs.fetchFromGitHub {
    owner = "dracula";
    repo = "gtk";
    rev = "58b8cf7f5d4099a644df322942549b26474faa04";
    sha256 = "1ga1d79fpdciaf0zqalfgb9704y5q0w2wfd6jj5d1q65qrikmj6q";
  };
  dracula-xresources = pkgs.fetchFromGitHub {
    owner = "dracula";
    repo = "xresources";
    rev = "8de11976678054f19a9e0ec49a48ea8f9e881a05";
    sha256 = "12wmjynk0ryxgwb0hg4kvhhf886yvjzkp96a5bi9j0ryf3pc9kx7";
  };

in {
  options.colorscheme.dracula = {
    enable = mkEnableOption "dracula colorscheme"; 
    colors = mkOption {
      type = types.attrsOf types.str;
      default = {};
    };
  };

  config.colorscheme.dracula.colors = {
    background = "#282a36";
    currentline = "#44475a";
    foreground = "#f8f8f2";
    comment = "#6272a4";
    cyan = "#8be9fd";
    green = "#50fa7b";
    orange = "#ffb86c";
    pink = "#ff79c6";
    purple = "#bd93f9";
    red = "#ff5555";
    yellow = "#f1fa8c";
  };

  config.home.packages = with pkgs; [
    lxqt.lxqt-qtplugin
    libsForQt5.qtstyleplugin-kvantum
    # xdg-desktop-portal
    papirus-icon-theme

    # for theme modification
    lxqt.lxqt-config
    xsettingsd
  ];

  config.home.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "lxqt";
  };

  config.xresources.extraConfig = builtins.readFile("${dracula-xresources}/Xresources");

  config.xdg = {
    dataFile = {
      "themes/Dracula".source = dracula-gtk;
    };
    configFile = {
      "Kvantum/Dracula/Dracula.kvconfig".source = "${dracula-gtk}/kde/kvantum/Dracula-purple-solid/Dracula-purple-solid.kvconfig";
      "Kvantum/Dracula/Dracula.svg".source = "${dracula-gtk}/kde/kvantum/Dracula-purple-solid/Dracula-purple-solid.svg";
      "Kvantum/kvantum.kvconfig".text = "[General]\ntheme=Dracula";
      "lxqt/lxqt.conf".source = ../../config/dracula/lxqt/lxqt.conf;
      "lxqt/session.conf".source = ../../config/dracula/lxqt/session.conf;
      "gtk-3.0/settings.ini".source = ../../config/dracula/gtk-3.0/settings.ini;
    };
  };

  config.home.file = {
    ".gtkrc-2.0".source = ../../config/dracula/gtk-2.0/gtkrc-2.0;
  };
}
