{ pkgs, ... }:

{
  xsession = {
    enable = true;
    windowManager.command = ''
      "${pkgs.unstable.qtile}/bin/qtile"
    '';
  };

  home.packages = with pkgs; [
    unstable.qtile
    dmenu
    picom
  ];
}
