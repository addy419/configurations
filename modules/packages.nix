{ config, pkgs, ... }:

# Include unstable branch
let
  unstable = import
    (builtins.fetchTarball https://github.com/nixos/nixpkgs/tarball/nixos-unstable)
    { config = config.nixpkgs.config; };
in
{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget git unzip killall
    # Preffered
    rcm unstable.alacritty neovim
    # Python
    (python3.withPackages(ps: with ps; [ requests ]))
    # Desktop
    polybar dmenu unstable.rofi picom feh
    # K
    kdeApplications.kdeconnect-kde
    # QT theme
    libsForQt5.qtstyleplugin-kvantum xdg-desktop-portal-kde
    # GTK theme
    papirus-icon-theme xdg-desktop-portal
    # Applets
    cbatticon gvolicon gnome3.networkmanagerapplet
    # Applications
    emacs okular
  ];
}
