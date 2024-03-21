{ pkgs, ... }:

{
  boot.initrd.kernelModules = [ "amdgpu" ];
  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      rocmPackages.clr.icd
      clinfo # To check if OpenCL is installed correctly
    ];
  };
}
