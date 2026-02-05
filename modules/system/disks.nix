{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    gparted
    sedutil
  ];

  #services.smartd = {
  #  enable = true;
  #};
}
