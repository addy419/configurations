{ current, ...}:

{
  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  services.fail2ban.enable = true;

  users.users.${current.user} = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJHn+s4moNvI0JPKoizl2/EfnKy/brPK+ZUo3po9nCjh"
    ];
  };

  services.autossh.sessions = [{
    name = "reverse-tunnel";
    user = "${current.user}"; # Runs as your local user to find your SSH keys
    monitoringPort = 0; # Disables the old, extra monitoring port (-M 0)
    extraArguments = "-N -o \"ServerAliveInterval 30\" -o \"ServerAliveCountMax 3\" -R 2222:localhost:22 nextcloud";
  }];
}
