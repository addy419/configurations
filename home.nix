let
  settings = import ./settings.nix;
  home-manager = builtins.fetchGit {
    url = "https://github.com/rycee/home-manager.git";
    ref = "release-${settings.nixosVersion}";
  };

in {
  imports = [ (import "${home-manager}/nixos") ];

  home-manager.users.${settings.wheelUser} = { ... }: {
    programs.git = {
      enable = true;
      userName = settings.gitName;
      userEmail = settings.gitEmail;
    };
  };
}
