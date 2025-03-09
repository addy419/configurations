{ current, ... }:

{
  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      data-root = "/home/${current.user}/.local/virt/docker";
    };
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };
  users.extraGroups.docker.members = [ current.user ];
  virtualisation.docker.storageDriver = "btrfs";
}
