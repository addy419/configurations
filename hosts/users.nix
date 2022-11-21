{ lib, config, options, ... }:
with lib;

let user = builtins.getEnv "USER";
    name = if elem user [ "" "root" ] then "aditya" else user;

in {
  # config.user now contain user info
  options = {
    user = mkOption {
      type = types.attrs;
      default = {};
    };
  };

  config = {
    user = {
      inherit name;
      extraGroups = [ "wheel" "networkmanager" "input" "video" ]; # sudo
      isNormalUser = true;
    };
    # Define a user account. Don't forget to set a password with ‘passwd’.
    # does not work without mkAliasDefinitions
    users.users.${config.user.name} = mkAliasDefinitions options.user;
  };
}
