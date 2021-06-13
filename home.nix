{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Systray
    stalonetray
    # Preffered
    alacritty neovim htop ripgrep
    # Python
    (python3.withPackages(ps: with ps; [ requests ]))
    # Lua
    (lua.withPackages(ps: with ps; [ lua-lsp ]))
    # Nix
    nixfmt
    # Desktop
    dmenu rofi picom
    # K
    libsForQt5.kdeconnect-kde
    # QT theme
    libsForQt5.qtstyleplugin-kvantum
    # GTK theme
    papirus-icon-theme xdg-desktop-portal numix-icon-theme
    # Applets
    cbatticon gvolicon nm-tray
    # Applications
    emacs neomutt mail-notification
  ];

  programs.git = {
    enable = true;
    userName = "Aditya Sadawarte";
    userEmail = "adityasadawarte01@gmail.com";
  };
}
