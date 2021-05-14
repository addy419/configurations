{ config, pkgs, ... }:
{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget git unzip killall
    # Preffered
    alacritty neovim htop
    # Python
    (python3.withPackages(ps: with ps; [ requests ]))
    # Lua
    (lua.withPackages(ps: with ps; [ lua-lsp ]))
    # Desktop
    polybar dmenu rofi picom feh
    # K
    kdeApplications.kdeconnect-kde
    # QT theme
    libsForQt5.qtstyleplugin-kvantum xdg-desktop-portal-kde
    # GTK theme
    papirus-icon-theme xdg-desktop-portal
    # Applets
    cbatticon gvolicon gnome3.networkmanagerapplet
    # Applications
    emacs
  ];
}
