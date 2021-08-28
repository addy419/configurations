{ inputs, ... }:

{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.aditya = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };

  # Home manager
  home-manager = {
    useUserPackages = true;
    users.aditya = import ./home.nix;
    extraSpecialArgs = { inherit inputs; };
  };
}
