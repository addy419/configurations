{ lib, inputs, config, options, ... }:
with lib;

let user = builtins.getEnv "USER";
    name = if elem user [ "" "root" ] then "aditya" else user;

in {
  # for home manager
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options = {
    user = mkOption {
      type = types.attrs;
      default = {};
    };
  };

  config = {
    user = {
      inherit name;
      extraGroups = [ "wheel" ]; # sudo
      isNormalUser = true;
    };
    # Define a user account. Don't forget to set a password with ‘passwd’.
    # does not work without mkAliasDefinitions
    users.users.${config.user.name} = mkAliasDefinitions options.user;
    # Home manager
    # expects hosts/{hostName}/home.nix, check orca/home.nix
    home-manager = {
      useUserPackages = true;
      users.${config.user.name} =  {
        imports = [ (../hosts/. + "/${config.networking.hostName}/home.nix") ];
        home.stateVersion = config.system.stateVersion;
      };
      extraSpecialArgs = { inherit inputs; };
    };
  };
}
