{
  description = "The work of a arch lunatic";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-21.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-21.05";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
  };

  outputs = { self, nixpkgs, ... } @ inputs:

  let hosts = { orca = "x86_64-linux"; };

  in {
    # expects default config in hosts/{hostName}/default.nix
    nixosConfigurations = nixpkgs.lib.mapAttrs (host: system: nixpkgs.lib.nixosSystem {
      system = system;
      modules = [ (./hosts/. + "/${host}") { networking.hostName = host; } ];
      specialArgs = { inherit inputs; };
    }) hosts;
  };
}
