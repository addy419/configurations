{ inputs, config, ... }:

{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./hardware-configuration.nix
    ../..
  ];

  # Home manager
  home-manager = {
    useUserPackages = true;
    users.${config.private.user.name} = import ../home.nix;
    extraSpecialArgs = { inherit inputs; };
  };
}
