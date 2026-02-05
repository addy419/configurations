{ pkgs, ... }:

{
  boot.initrd.kernelModules = [ "amdgpu" ];

  hardware.amdgpu = {
    opencl.enable = true;
    initrd.enable = true;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # OpenCL
  hardware.graphics.extraPackages = with pkgs; [ rocmPackages.clr.icd ];

  # HIP
  systemd.tmpfiles.rules =
  let rocmEnv = pkgs.symlinkJoin {
      name = "rocm-combined";
      paths = with pkgs.rocmPackages; [
        clr
        hipfort
      ];
    };
      in [
    "L+    /opt/rocm/hip   -    -    -     -    ${rocmEnv}"
  ];


  environment.systemPackages = with pkgs; [
    clinfo
  ];

  # AMD issue with direct scanout on COSMIC
  environment.sessionVariables.COSMIC_DISABLE_DIRECT_SCANOUT = 1;
}
