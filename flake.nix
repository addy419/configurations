{
  description =
    "The work of a arch lunatic *scratch that* chronic distro hopper";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.11";
    homeManager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.3.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    devenv.url = "github:cachix/devenv";
    flake-utils.url = "github:numtide/flake-utils";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nur.url = "github:nix-community/NUR";
    hardened-firefox = {
      url = "github:arkenfox/user.js";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, devenv, ... }@inputs:

    let
      lib = nixpkgs.lib;
      currentSystem = builtins.getEnv "SYSTEM";
      system = if currentSystem == "" then "x86_64-linux" else currentSystem;
      currentUser = builtins.getEnv "USER";
      user = if lib.elem currentUser [ "" "root" ] then "aditya" else currentUser;
      pkgs = import nixpkgs { inherit system; };
      overlays = [ ];
    in {
      # Develpment environment shells
      devShells.${pkgs.system} = {
        py = devenv.lib.mkShell {
          inherit inputs pkgs;
          modules = [{
            languages.python.enable = true;
            languages.python.venv.enable = true;
            packages = with pkgs;
              [
                (python3.withPackages (ps:
                  with ps; [
                    wheel
                    jupyter
                    numpy
                    pandas
                    scikit-learn
                    nltk
                    scipy
                    matplotlib
                  ]))
              ];
          }];
        };
      };

      # NixOS Configuration
      # Expects default config in hosts/{hostName}/configuration.nix
      nixosConfigurations = lib.mapAttrs (hostName: system:
        lib.nixosSystem {
          inherit system;
          modules = [ ./hosts/imports.nix ];
          specialArgs = {
            inherit inputs;
            current = {
              inherit hostName;
              inherit user;
              inherit system;
              inherit overlays;
            };
          };
        }) (lib.mapAttrs (path: type: system)
          (lib.filterAttrs (path: type: type == "directory")
            (builtins.readDir ./hosts)));
    };
}
