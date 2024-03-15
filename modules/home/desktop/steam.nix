{ pkgs, ... }:

{
  home.packages = with pkgs; [
    steamtinkerlaunch
    unixtools.xxd
    xorg.xwininfo
    xdotool
    xorg.xprop
    jq
    p7zip
    xorg.xrandr
  ];
}
