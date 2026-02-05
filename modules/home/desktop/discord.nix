{ pkgs, ... }:

{
  home.packages = with pkgs; [
    discord-ptb
  ];

  home.sessionVariables.NIXOS_OZONE_WL = "1";
}
