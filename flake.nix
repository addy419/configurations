{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-21.05";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager }: {

    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules =
        [ #({ pkgs, ... }: {
           # boot.isContainer = true;

            # Let 'nixos-version --json' know about the Git revision
            # of this flake.
            #system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;

            # Network configuration.
            #networking.useDHCP = false;
            #networking.firewall.allowedTCPPorts = [ 80 ];

            # Enable a web server.
            #services.httpd = {
            #  enable = true;
            #  adminAddr = "morty@example.org";
            #};
          #})
          ./hardware-configuration.nix
          ./modules/packages.nix
          ./configuration.nix
        ];
    };

  };
}
