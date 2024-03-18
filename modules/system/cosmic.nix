{ inputs, ... }:

{
  imports = [ inputs.nixos-cosmic.nixosModules.default ];

  services.xserver.displayManager.cosmic-greeter.enable = true;
  services.xserver.desktopManager.cosmic.enable = true;
}
