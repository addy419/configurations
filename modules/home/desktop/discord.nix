{ pkgs, ... }:

{
  home.packages = with pkgs; [
    webcord
  ];

  home.sessionVariables.NIXOS_OZONE_WL = "1";
}
