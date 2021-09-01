{ lib, inputs, config, ... }:
with lib;

let user = builtins.getEnv "USER";
    name = if elem user [ "" "root" ] then "aditya" else user;

in {
  options.private = {
    user = mkOption {
      type = types.attrs;
    };
  };

  config.private = {
    user = {
      inherit name;
      description = "The primary user account";
      extraGroups = [ "wheel" ];
      isNormalUser = true;
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${config.private.user.name} = config.private.user;
}
