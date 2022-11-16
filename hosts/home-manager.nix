{ inputs, config, ... }:

{
  imports = [ inputs.homeManager.nixosModules.home-manager ];

  # expects hosts/{hostName}/{userName}-home.nix, check orca/aditya-home.nix
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${config.user.name} =  {
      imports = [ (./. + "/${config.networking.hostName}/${config.user.name}-home.nix") ];
      home.stateVersion = config.system.stateVersion;
    };
    extraSpecialArgs = { inherit inputs; };
  };
}
