{ pkgs, ... }:

{
  home.packages = with pkgs; [
    ghostty
  ];
  #programs.ghostty = {
  #  enable = true;
  #  enableBashIntegration = true;
  #  installVimSyntax = true;
  #  settings = {
  #    font-size = 10;
  #  };
  #};
}
