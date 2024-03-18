{
  boot = {
    kernelModules = [ "hid-apple" ];
    extraModprobeConfig = ''
      options hid_apple fnmode=2
    '';
  };
}
