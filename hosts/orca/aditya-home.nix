{ inputs, pkgs, config, ... }:

{
  # Yes home.nix, your refactoring time will arrive soon
  # Alas, it never did
  imports = [ ../../modules/home ];

  home.packages = with pkgs; [
    htop
    fastfetch
    #(libsForQt5.kdeconnect-kde.overrideAttrs (oldAttrs: {
    #  buildInputs = oldAttrs.buildInputs ++ [ libsForQt5.qtconnectivity ];
    #  cmakeFlags = (oldAttrs.cmakeFlags or []) ++ [ "-DBLUETOOTH_ENABLED=ON" ];
    #}))
    pavucontrol
    xournalpp
    wl-clipboard
    wev
    zip
    sqlite
    chromium
    signal-desktop
    qt6.qtwayland
    qt5.qtwayland
    mpv
    ffmpeg
    image-roll
    poppler_utils
    nextcloud-client
    zotero_7
    audacity
    ethtool
    qpwgraph
    # vrrtest
    gnumake
    gdb
    amdgpu_top
    foliate
    guvcview
    evince
  ];

  systemd.user.services.mpris-proxy = {
    Unit.Description = "Mpris proxy";
    Unit.After = [ "network.target" "sound.target" ];
    Service.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
    Install.WantedBy = [ "default.target" ];
  };

  services.kdeconnect = {
    enable = true;
    package = pkgs.kdePackages.kdeconnect-kde;
    indicator = true;
  };
}
