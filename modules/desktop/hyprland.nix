{ inputs, pkgs, ... }:

{
  imports = [ inputs.hyprland.homeManagerModules.default ];
  wayland.windowManager.hyprland = {
    enable = true;
    #extraConfig = builtins.readFile ../../config/hyprland/hyprland.conf;
    extraConfig = ''
      source=~/.config/hypr/config.conf
    '';
  };
}
