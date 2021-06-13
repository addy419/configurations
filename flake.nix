{
  description = "The work of a arch lunatic";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-21.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager }: {

    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules =
        [ ({ pkgs, ... }: {
            # Let 'nixos-version --json' know about the Git revision
            # of this flake.
            system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
          })
          ./hardware-configuration.nix
          ./modules/packages.nix
          ./configuration.nix
        ];
    };

  };
}
