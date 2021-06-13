{
  description = "The work of a arch lunatic";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-21.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    nix-doom-emacs = {
      url = "github:vlaci/nix-doom-emacs";
      inputs.emacs-overlay.follows = "emacs-overlay";
    };
  };

  outputs = { self, nixpkgs, ... } @ inputs: {

    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules =
        [ 
          ./default.nix
          {
            # Let 'nixos-version --json' know about the Git revision
            # of this flake.
            system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
          }
        ];
        specialArgs = { inherit inputs; };
    };
  };
}
