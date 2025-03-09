{ pkgs, ... }:

{

  environment.systemPackages = with pkgs; [
    mangohud
    protontricks
    winetricks
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = false; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = false; # Open ports in the firewall for Source Dedicated Server
    gamescopeSession = {
      enable = true;
      args = [ 
        "-f"
        "-e"
        "-W 2560"
        "-H 1440"
        "-w 2560"
        "-h 1440"
        "-r 120"
        "--adaptive-sync"
        "--mangoapp"
      ];
    };
  };

  # programs.gamemode = {
  #   enable = true;
  #   enableRenice = true;
  #   settings = {
  #     general = {
  #       softrealtime = "auto";
  #       renice = 10;
  #     };
  #     custom = {
  #       start = "notify-send -a 'Gamemode' 'Optimizations activated'";
  #       end = "notify-send -a 'Gamemode' 'Optimizations deactivated'";
  #     };
  #   };
  # };
}
