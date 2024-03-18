{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        ControllerMode = "dual";
        FastConnectable = true;
        Experimental = true;
      };
    };
  };

  services.blueman.enable = true;
}
