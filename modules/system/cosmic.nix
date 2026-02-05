{ inputs, pkgs, ... }:

{
  #imports = [ inputs.nixos-cosmic.nixosModules.default ];

  services.displayManager.cosmic-greeter.enable = true;
  services.desktopManager.cosmic = {
    enable = true;
    xwayland.enable = true;
  };

  environment.systemPackages = with pkgs; [
    # Not available in NixPkgs yet
    #cosmic-ext-applet-emoji-selector
    #cosmic-ext-applet-external-monitor-brightness
    forecast
  ];

  environment.sessionVariables.COSMIC_DATA_CONTROL_ENABLED = 1;
}
