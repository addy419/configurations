{ config, pkgs, ... }:

{
  services.sxhkd = {
    enable = true;
    keybindings = {
      # make sxhkd reload its configuration files:
      "super + Escape" = "pkill -USR1 -x sxhkd";
    };
    extraOptions = [ "-s ${config.xdg.configHome}/sxhkd/sxhkd.fifo" ];
  };

  systemd.user.tmpfiles.rules = [ "p ${config.xdg.configHome}/sxhkd/sxhkd.fifo" ];
}
