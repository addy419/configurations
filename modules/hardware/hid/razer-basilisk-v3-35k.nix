{ pkgs, current, ... }:

{
  #hardware.openrazer.enable = true;
  #environment.systemPackages = with pkgs; [
  #  openrazer-daemon
  #  polychromatic
  #];

  #users.extraGroups.openrazer.members = [ current.user ];
    #SUBSYSTEM=="usb", ATTRS{idVendor}=="1532", MODE="0666", GROUP="plugdev"
  services.udev.extraRules = ''
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1532", ATTRS{idProduct}=="00cb", TAG+="uaccess", MODE="0666"
  '';
  users.extraGroups.plugdev.members = [ current.user ];
}
