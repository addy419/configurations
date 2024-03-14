{ pkgs, ... }:

{
  home.packages = with pkgs; [
    hunspell
    hunspellDicts.en-gb-large
  ];
}
