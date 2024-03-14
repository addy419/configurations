{ lib, config, pkgs, ... }:

{
  home.packages = with pkgs; [
    tealdeer
  ];

  programs.bash = {
    enable = true;
    historyControl = [ "ignoredups" ];
    shellAliases.wdcs =
      "${pkgs.sshpass}/bin/sshpass -f ${config.home.homeDirectory}/.dcs-vnc ssh dcs-vnc";
    shellAliases.scrtp =
      "${pkgs.sshpass}/bin/sshpass -f ${config.home.homeDirectory}/.scrtp ssh scrtp";
  };

  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    settings = {
      add_newline = true;
      line_break = { disabled = true; };
      directory = {
        read_only = " RO";
        read_only_style = "bold red";
      };
      git_branch = { format = "on [$branch(:$remote_branch)]($style) "; };
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "➜";
      };
    };
  };
}
