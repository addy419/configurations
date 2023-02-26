{
  description = "The work of a arch lunatic *scratch that* chronic distro hopper";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    homeManager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nur.url = "github:nix-community/NUR";
    hyprland = {
      url = "github:hyprwm/Hyprland";
    };
    mozilla-addons-to-nix = {
      url = "sourcehut:~rycee/mozilla-addons-to-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    hardened-firefox = {
      url = "github:arkenfox/user.js";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, ... }@inputs:

    let
      lib = nixpkgs.lib;

      currentSystem = builtins.getEnv "SYSTEM";
      system = if currentSystem == "" then "x86_64-linux" else currentSystem;
      currentUser = builtins.getEnv "USER";
      user = if lib.elem currentUser [ "" "root" ] then "aditya" else currentUser;

      discordOverlay = self: prev: {
        discord = prev.discord.override { withOpenASAR = true; };
      };
      #overlays = [ discordOverlay ];
      overlays = [  ];
    in {
      # expects default config in hosts/{hostName}/configuration.nix
      nixosConfigurations = lib.mapAttrs (hostName: system:
        lib.nixosSystem {
          inherit system;
          modules = [ (./hosts/. + "/${hostName}/configuration.nix") ];
          specialArgs = {
            inherit inputs;
            current = { inherit hostName; inherit user; inherit overlays; }; };
        }) (lib.mapAttrs (path: type: system) (lib.filterAttrs (path: type: type == "directory") (builtins.readDir ./hosts)));
    };
}
