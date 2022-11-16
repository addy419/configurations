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
    nm-tray
    # Applications
    libsForQt5.kdeconnect-kde
    #neomutt
    lxqt.pcmanfm-qt
    lxqt.lxqt-archiver
    # wayland
    #foot
    firefox
  ];
  
  #services.kdeconnect = {
  #  enable = true;
  #  indicator = false;
  #};

  fonts.fontconfig.enable = true;
}
