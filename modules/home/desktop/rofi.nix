{ pkgs, config, ... }:

let
  rofi-config = ../../../config/rofi/config.rasi;
  rofi-config-no-icons = pkgs.writeText "config.rasi" (
    builtins.readFile(rofi-config) + ''
      
      configuration {
        show-icons: false;
      }
      ''
  );

in {
  home.packages = with pkgs; [
    rofi-wayland
    #(rofi.override { 
    #  plugins = with pkgs; [ rofi-emoji ];
    #})
  ];

  xdg.configFile = {
    "rofi/config.rasi".text = ''
      @theme "${rofi-config}"
    '';
    "rofi/config-no-icons.rasi".text = ''
      @theme "${rofi-config-no-icons}"
    '';
  };

  #xsession = {
  #  windowManager.qtile = {
  #    keybindings = {
  #      "mod1 + Tab" = "lazy.spawn(\"rofi -modi window -show window\")";
  #      "mod + d" = "lazy.spawn(\"rofi -modi drun -show drun\")";
  #      "mod + period" = "lazy.spawn(\"rofi -modi emoji -show emoji -config ${config.xdg.configHome}/rofi/config-no-icons.rasi\")";
  #    };
  #  };
  #};
}
