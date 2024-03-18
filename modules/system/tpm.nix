{ pkgs, ... }:

{
  boot.initrd.systemd.enable = true;

  environment.systemPackages =  with pkgs; [
    tpm2-tss
  ];
}
