{ current, ... }:

{
  imports =
    [
      (./. + "/${current.hostName}/hardware-configuration.nix")
      (./. + "/${current.hostName}/configuration.nix")
      ./home-manager.nix
      ../modules/system
    ];
}
