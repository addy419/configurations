{ config, inputs, pkgs, ... }:

let
  dracula-gtk = pkgs.fetchFromGitHub {
    owner = "dracula";
    repo = "gtk";
    rev = "502f212d83bc67e8f0499574546b99ec6c8e16f9";
    sha256 = "1wx9nzq7cqyvpaq4j60bs8g7gh4jk8qg4016yi4c331l4iw1ymsa";
  };
  dracula-xresources = pkgs.fetchFromGitHub {
    owner = "dracula";
    repo = "xresources";
    rev = "8de11976678054f19a9e0ec49a48ea8f9e881a05";
    sha256 = "12wmjynk0ryxgwb0hg4kvhhf886yvjzkp96a5bi9j0ryf3pc9kx7";
  };

in {
  home.packages = with pkgs; [
    lxqt.lxqt-qtplugin
    libsForQt5.qtstyleplugin-kvantum
    xdg-desktop-portal
    papirus-icon-theme
  ];

  home.sessionVariables = {
    GTK_USE_PORTAL = "1";
    QT_QPA_PLATFORMTHEME = "lxqt";
  };

  xresources.extraConfig = builtins.readFile("${dracula-xresources}/Xresources");

  xdg = {
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

  home.file = {
    ".gtkrc-2.0".source = ../../config/dracula/gtk-2.0/gtkrc-2.0;
  };
}
