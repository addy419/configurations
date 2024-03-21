{ inputs, pkgs, config, ... }:

{
  # Yes home.nix, your refactoring time will arrive soon
  imports = [ ../../modules/home ];

  home.packages = with pkgs; [
    htop
    neofetch
    networkmanagerapplet
    gnumake
    # Applications
    #(libsForQt5.kdeconnect-kde.overrideAttrs (oldAttrs: {
    #  buildInputs = oldAttrs.buildInputs ++ [ libsForQt5.qtconnectivity ];
    #  cmakeFlags = (oldAttrs.cmakeFlags or []) ++ [ "-DBLUETOOTH_ENABLED=ON" ];
    #}))
    #neomutt
    lxqt.pcmanfm-qt
    lxqt.lxqt-archiver
    brightnessctl
    pavucontrol
    glib
    tigervnc
    libsForQt5.okular
    #pulseaudio
    grim
    slurp
    wl-clipboard
    wev
    zip
    sqlite
    chromium
    virt-manager
    signal-desktop
    qt6.qtwayland
    qt5.qtwayland
    mpv
    image-roll
    wdisplays
    poppler_utils
    protonup-qt
    inkscape
    zotero_7
    ethtool
    vrrtest
    mangohud
    glxinfo
    goverlay
    geekbench
    gdb
    ventoy-full
  ];

  programs.waybar = {
    enable = true;
  };

  #services.swayidle = {
  #  enable = true;
  #  systemdTarget = "hyprland-session.target";
  #  events = [
  #    #{
  #    #  event = "before-sleep";
  #    #  command = "${pkgs.python3}/bin/python3 /opt/batterylog/batterylog.py suspend & ${pkgs.swaylock}/bin/swaylock";
  #    #}
  #    #{
  #    #  event = "after-resume";
  #    #  command = "${pkgs.python3}/bin/python3 /opt/batterylog/batterylog.py resume";
  #    #}
  #    {
  #      event = "lock";
  #      command = "${pkgs.swaylock}/bin/swaylock";
  #    }
  #  ];
  #  timeouts = [
  #    {
  #      timeout = 120;
  #      command = "${pkgs.brightnessctl}/bin/brightnessctl -sc backlight set 10%";
  #      resumeCommand = "${pkgs.brightnessctl}/bin/brightnessctl -rc backlight";
  #    }
  #    { 
  #      timeout = 300;
  #      command = "${pkgs.systemd}/bin/systemctl suspend";
  #    }
  #  ];
  #};

  systemd.user.services.mpris-proxy = {
    Unit.Description = "Mpris proxy";
    Unit.After = [ "network.target" "sound.target" ];
    Service.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
    Install.WantedBy = [ "default.target" ];
  };

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-vkcapture
    ];
  };
}
