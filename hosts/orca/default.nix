{ inputs, ... }:

{
  #nixosConfigurations.kraken = nixpkgs.lib.nixosSystem {
  #  system = "x86_64-linux";
  #  modules = [ { networking.hostName = "orca"; } ];
  #  specialArgs = { inherit inputs; };
  #};

  nixosConfigurations.orca = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./default.nix { networking.hostName = "orca"; } ];
      specialArgs = { inherit inputs; };
  };
}
