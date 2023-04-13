{ inputs, pkgs, config, ... }:

{
  # Yes home.nix, your refactoring time will arrive soon
  imports = [
    ../../modules/essential/spell.nix
    ../../modules/essential/shell.nix
    ../../modules/dev/git.nix
    ../../modules/dev/latex.nix
    ../../modules/dev/java.nix
    ../../modules/colorschemes/dracula.nix
    #../../modules/desktop/qtile.nix
    ../../modules/desktop/office.nix
    ../../modules/desktop/notification.nix
    ../../modules/desktop/fonts.nix
    ../../modules/desktop/alacritty.nix
    #../../modules/desktop/urxvt.nix
    ../../modules/desktop/rofi.nix
    ../../modules/editors/emacs.nix
    ../../modules/editors/neovim.nix
    ../../modules/desktop/hyprland.nix
    ../../modules/desktop/discord.nix
    ../../modules/desktop/firefox
    ../../modules/desktop/steam.nix
#    ../../external-modules/nwg-look.nix
  ];

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
    bitwarden
    pulseaudio
    grim
    slurp
    wl-clipboard
    wev
    zip
    sqlite
    chromium
    swaylock
    virt-manager
    signal-desktop
    qt6.qtwayland
    qt5.qtwayland
    mpv
    swayimg
    amberol
    wdisplays
  ];

  programs.waybar = {
    enable = true;
    package = pkgs.waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ ["-Dexperimental=true"];
      patchPhase = ''
        substituteInPlace src/modules/wlr/workspace_manager.cpp --replace "zext_workspace_handle_v1_activate(workspace_handle_);" "const std::string command = \"${config.wayland.windowManager.hyprland.package}/bin/hyprctl dispatch workspace \" + name_; system(command.c_str());"
      '';
    });
  };

  services.swayidle = {
    enable = true;
    systemdTarget = "hyprland-session.target";
    events = [
      {
        event = "before-sleep";
        command = "${pkgs.python3}/bin/python3 /opt/batterylog/batterylog.py suspend & ${pkgs.swaylock}/bin/swaylock";
      }
      {
        event = "after-resume";
        command = "${pkgs.python3}/bin/python3 /opt/batterylog/batterylog.py resume";
      }
      {
        event = "lock";
        command = "${pkgs.swaylock}/bin/swaylock";
      }
    ];
    timeouts = [
      {
        timeout = 120;
        command = "${pkgs.brightnessctl}/bin/brightnessctl -sc backlight set 10%";
        resumeCommand = "${pkgs.brightnessctl}/bin/brightnessctl -rc backlight";
      }
      { 
        timeout = 300;
        command = "${pkgs.systemd}/bin/systemctl suspend";
      }
    ];
  };

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
