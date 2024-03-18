{ pkgs, ... }:

{
  home.packages = with pkgs; [
    texlive.combined.scheme-small
    texlab
  ];
}
