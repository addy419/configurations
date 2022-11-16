{ pkgs, config, ...}:

{
  home.packages = with pkgs; [
    libnotify
    lxqt.lxqt-notificationd
    picom
    #dunst
  ];

  #systemd.user.services.lxqt-notificationd = {
  #  Unit = {
  #    Description = "notification daemon for the lxqt desktop environment";
  #    Requires = [ "tray.target" ];
  #    After = [ "graphical-session-pre.target" "tray.target" ];
  #    PartOf = [ "graphical-session.target" ];
  #  };
  #  Install = { WantedBy = [ "graphical-session.target" ]; };
  #  Service = {
  #    #Type = "dbus";
  #    #BusName = "org.freedesktop.Notifications";
  #    Environment = "PATH=${config.home.profileDirectory}/bin";
  #    ExecStart = "${pkgs.lxqt.lxqt-notificationd}/bin/lxqt-notificationd";
  #    #Restart = "on-failure";
  #  };
  #  #wantedBy = [ "multi-user.target" ];
  #};

  #services.dunst = {
  #  enable = false;
  #};
}
