{ inputs, pkgs, ... }:

{
  imports = [ inputs.nixos-cosmic.nixosModules.default ];

  services.displayManager.cosmic-greeter.enable = true;
  services.desktopManager.cosmic.enable = true;

  environment.systemPackages = with pkgs; [
    cosmic-ext-applet-emoji-selector
    cosmic-ext-applet-external-monitor-brightness
    forecast
  ];
}
