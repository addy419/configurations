{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    libnotify
    glib
  ];
}
