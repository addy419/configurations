{ inputs, pkgs, config, ... }:

{
  # Yes home.nix, your refactoring time will arrive soon
  # Alas, it never did
  imports = [ ../../modules/home ];

  home.packages = with pkgs; [
    htop
    fastfetch
    pavucontrol
    #xournalpp
    wl-clipboard
    wev
    zip
    chromium
    signal-desktop
    qt6.qtwayland
    qt5.qtwayland
    mpv
    ffmpeg
    image-roll
    poppler-utils
    nextcloud-client
    lrcget
    zotero
    audacity
    ethtool
    qpwgraph
    # vrrtest
    gnumake
    gdb
    amdgpu_top
    foliate
    guvcview
    #evince
    syncplay
    yt-dlp
    authenticator
    door-knocker
    supersonic-wayland
    ydotool
    stress-ng
  ];

  systemd.user.services.mpris-proxy = {
    Unit.Description = "Mpris proxy";
    Unit.After = [ "network.target" "sound.target" ];
    Service.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
    Install.WantedBy = [ "default.target" ];
  };

  #services.kdeconnect = {
  #  enable = true;
  #  package = pkgs.kdePackages.kdeconnect-kde;
  #  indicator = true;
  #};
}
