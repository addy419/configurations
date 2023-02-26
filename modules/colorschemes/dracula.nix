{ lib, config, inputs, pkgs, ... }:
with lib;

let
  cfg = config.colorscheme.dracula;
  dracula-gtk = pkgs.fetchFromGitHub {
    owner = "dracula";
    repo = "gtk";
    rev = "bc098d48e966870548e798f5d6d0a38e3b48c884";
    sha256 = "1923jyvji2s6a3nx0kzzgzjk6qlnsp6dyc0vyd370paiif3clzrb";
  };
  dracula-xresources = pkgs.fetchFromGitHub {
    owner = "dracula";
    repo = "xresources";
    rev = "8de11976678054f19a9e0ec49a48ea8f9e881a05";
    sha256 = "12wmjynk0ryxgwb0hg4kvhhf886yvjzkp96a5bi9j0ryf3pc9kx7";
  };
  configure-gtk = pkgs.writeTextFile {
    name = "configure-gtk";
    destination = "/bin/configure-gtk";
    executable = true;
    text = let
      schema = pkgs.gsettings-desktop-schemas;
      datadir = "${schema}/share/gsettings-schemas/${schema.name}";
    in ''
      export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
      gnome_schema=org.gnome.desktop.interface
      config="${../../config/dracula/gtk-3.0/settings.ini}"

      gtk_theme="$(grep 'gtk-theme-name' "$config" | sed 's/.*\s*=\s*//')"
      icon_theme="$(grep 'gtk-icon-theme-name' "$config" | sed 's/.*\s*=\s*//')"
      cursor_theme="$(grep 'gtk-cursor-theme-name' "$config" | sed 's/.*\s*=\s*//')"
      font_name="$(grep 'gtk-font-name' "$config" | sed 's/.*\s*=\s*//')"
      
      gsettings set "$gnome_schema" gtk-theme "$gtk_theme"
      gsettings set "$gnome_schema" icon-theme "$icon_theme"
      gsettings set "$gnome_schema" cursor-theme "$cursor_theme"
      gsettings set "$gnome_schema" font-name "$font_name"
    '';
  };

in {
  options.colorscheme.dracula = {
    enable = mkEnableOption "dracula colorscheme";
    colors = mkOption {
      type = types.attrsOf types.str;
      default = { };
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
    papirus-icon-theme

    # for wayland
    configure-gtk
    # for theme modification
    lxqt.lxqt-config
    xsettingsd
  ];

  config.xresources.extraConfig =
    builtins.readFile ("${dracula-xresources}/Xresources");

  config.xdg = {
    dataFile = {
      "themes/Dracula".source = dracula-gtk;
      "icons/Dracula-cursors".source = "${dracula-gtk}/kde/cursors/Dracula-cursors";
    };
    configFile = {
      "Kvantum/Dracula/Dracula.kvconfig".source =
        "${dracula-gtk}/kde/kvantum/Dracula-purple-solid/Dracula-purple-solid.kvconfig";
      "Kvantum/Dracula/Dracula.svg".source =
        "${dracula-gtk}/kde/kvantum/Dracula-purple-solid/Dracula-purple-solid.svg";
      "Kvantum/kvantum.kvconfig".text = ''
        [General]
        theme=Dracula'';
      "lxqt/lxqt.conf".source = ../../config/dracula/lxqt/lxqt.conf;
      "lxqt/session.conf".source = ../../config/dracula/lxqt/session.conf;
      "gtk-3.0/settings.ini".source = ../../config/dracula/gtk-3.0/settings.ini;
    };
  };

  config.home.file = {
    ".gtkrc-2.0".source = ../../config/dracula/gtk-2.0/gtkrc-2.0;
    ".icons".source = ../../config/dracula/icons;
    ".Xdefaults".source = ../../config/dracula/Xdefaults;
  };
}
