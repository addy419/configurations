{ inputs, current, config, ... }:

{
  imports = [ inputs.homeManager.nixosModules.home-manager ];

  # expects hosts/{hostName}/{userName}-home.nix, check orca/aditya-home.nix
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${current.user} =  {
      imports = [ (./. + "/${current.hostName}/${current.user}-home.nix") ];
      home.stateVersion = config.system.stateVersion;
    };
    extraSpecialArgs = { inherit inputs; inherit current; };
  };
}
