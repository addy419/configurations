{ inputs, ... }:

{
  imports = [
    inputs.webcord.homeManagerModules.default
  ];

  programs.webcord = {
  enable = true;
  };

  home.sessionVariables.NIXOS_OZONE_WL = "1";
}
