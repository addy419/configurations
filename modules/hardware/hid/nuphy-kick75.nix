{ pkgs, current, ... }:

{
  services.udev.extraRules = ''
    # For NuPhyIO
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="19f5", ATTRS{idProduct}=="1026", TAG+="uaccess", MODE="0666"
    # For NuPhyIO updater
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="19f5", ATTRS{idProduct}=="0720", TAG+="uaccess", MODE="0666"
  '';
  users.extraGroups.plugdev.members = [ current.user ];
}
