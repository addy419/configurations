{ inputs, pkgs, config, ... }:

{
  # Yes home.nix, your refactoring time will arrive soon
  imports = [
    ../../modules/dev/git.nix
    ../../modules/colorschemes/dracula.nix
    ../../modules/desktop/qtile.nix
    #../../modules/desktop/bspwm.nix
    #../../modules/desktop/sxhkd.nix
    #../../modules/desktop/polybar.nix
    ../../modules/desktop/notification.nix
    ../../modules/desktop/fonts.nix
    ../../modules/desktop/urxvt.nix
    ../../modules/desktop/rofi.nix
    ../../modules/editors/emacs.nix
    ../../modules/editors/neovim.nix
  ];

  home.packages = with pkgs; [
    htop
    neofetch
    # in case on no wm keybindings
    xorg.xkill
    # Python
    #(python3.withPackages (ps: with ps; [ requests ]))
    # Desktop
    #feh
    #cinnamon.pix
    # Applets
    cbatticon
    gvolicon
    #nm-tray
    networkmanagerapplet
    # Applications
    libsForQt5.kdeconnect-kde
    #neomutt
    lxqt.pcmanfm-qt
    lxqt.lxqt-archiver
    # wayland
    foot
    #dconf
    font-manager
#    phinger-cursors
    glib
    dmenu-wayland
    discord
    tigervnc
    alacritty
    libsForQt5.okular
    bitwarden
    ksnip
    steam
    texlive.combined.scheme-full
  ];

  services.kdeconnect = {
    enable = true;
    indicator = true;
  };
  
  programs.bash = {
    enable = true;
    shellAliases.wdcs = "${pkgs.sshpass}/bin/sshpass -f ${config.home.homeDirectory}/.dcs-vnc ssh dcs-vnc";
  };

  systemd.user.services.mpris-proxy = {
    Unit.Description = "Mpris proxy";
    Unit.After = [ "network.target" "sound.target" ];
    Service.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
    Install.WantedBy = [ "default.target" ];
  };

  # Home Manager programs.firefox style
  programs.firefox = {
    enable = true;
  #  package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
  #    forceWayland = true;
  #    extraPolicies = {
  #      ExtensionSettings = {};
  #    };
  #  };
  };
  
  #home.sessionVariables = {
  #  MOZ_ENABLE_WAYLAND = "1";
  #  MOZ_USE_XINPUT2 = "1";
  #  XDG_CURRENT_DESKTOP = "river";
  #};
}
