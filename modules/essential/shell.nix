{ lib, config, pkgs, ... }:

{
  #home.packages = with pkgs; [
  #  starship
  #];

  programs.bash = {
    enable = true;
    shellAliases.wdcs =
      "${pkgs.sshpass}/bin/sshpass -f ${config.home.homeDirectory}/.dcs-vnc ssh dcs-vnc";
  };

  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    settings = {
      add_newline = true;
      #format = lib.concatStrings [
      #  "$line_break"
      #  "$package"
      #  "$line_break"
      #  "$character"
      #];
      #scan_timeout = 10;
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "➜";
      };
    };
  };
}
