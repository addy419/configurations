{ config, pkgs, ... }:

{
  services.sxhkd = {
    enable = true;
    keybindings = {
      # terminal emulator
      "super + Return" = "urxvt";
      "super + t" = "alacritty";
      # connect to emacs daemon
      "super + e" = "emacsclient -c";
      # make sxhkd reload its configuration files:
      "super + Escape" = "pkill -USR1 -x sxhkd";
    };
    extraOptions = [ "-s ${config.xdg.configHome}/sxhkd/sxhkd.fifo" ];
  };

  systemd.user.tmpfiles.rules = [ "p ${config.xdg.configHome}/sxhkd/sxhkd.fifo" ];
}
