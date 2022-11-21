{
  description = "The work of a arch lunatic *scratch that* chronic distro hopper";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    # nixpkgs.url = "nixpkgs/nixos-22.05";
    # nixpkgsUnstable.url = "nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    homeManager = {
      # url = "github:nix-community/home-manager/release-22.05";
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emacsOverlay.url = "github:nix-community/emacs-overlay";
  };

  outputs = { self, nixpkgs, nixpkgsUnstable, emacsOverlay, ... }@inputs:

    let
      hosts = {
        orca = "x86_64-linux";
        virt = "x86_64-linux";
      };
      allowUnfree = true; # *gasps* richard senpai, are you watching this?
      # unstableOverlay = final: prev: {
      #   unstable = import nixpkgsUnstable {
      #     system = prev.system;
      #     config = { inherit allowUnfree; };
      #   };
      # };
      # overlays = [ unstableOverlay emacsOverlay.overlay ];
      overlays = [ emacsOverlay.overlay ];

    in {
      # expects default config in hosts/{hostName}/configuration.nix
      nixosConfigurations = nixpkgs.lib.mapAttrs (host: system:
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            (./hosts/. + "/${host}/configuration.nix")
            {
              networking.hostName = host;
              nixpkgs = { 
                inherit overlays;
                config = { inherit allowUnfree; };
              };
            }
          ];
          specialArgs = { inherit inputs; };
        }) hosts;
    };
}
