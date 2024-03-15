{ pkgs, config, ...}:

{
  home.packages = with pkgs; [
    swaynotificationcenter
    libnotify
  ];
}
