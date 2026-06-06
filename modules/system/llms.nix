{ pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.llama-cpp-rocm
  ];
}
