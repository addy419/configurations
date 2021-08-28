{ pkgs, ... }:

{
  xsession = {
    enable = true;
    windowManager.command = ''
      "${pkgs.herbstluftwm}/bin/herbstluftwm"
    '';
  };

  home.packages = with pkgs; [
    herbstluftwm
    dmenu
    picom
  ];
}
