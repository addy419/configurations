# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, current, config, pkgs, lib, ... }:

{
  # Enable flakes
  nix = {
    package = pkgs.nixUnstable;
    settings = {
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  nixpkgs = { 
    overlays = current.overlays;
    config = { allowUnfree = true; };
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # Set host name
  networking.hostName = current.hostName;
  
  # Enables wireless support
  networking.networkmanager.enable = true;

  # Enable bluetooth support
  hardware.bluetooth = {
    enable = true;
    settings = {
      General = {
        Name = "BT5.2";
        ControllerMode = "dual";
        FastConnectable = "true";
        Experimental = "true";
      };
      Policy = {
        AutoEnable = "true";
      };
    };
  };
  services.blueman.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";
  console = {
  # font = "Lat2-Terminus16";
  # keyMap = "us";
     useXkbConfig = true; # use xkbOptions in tty.
  };

  #programs.regreet.enable = true;
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
        user = "greeter";
        vt = "next";
      };
    };
  };
  programs.hyprland = {
    enable = true;
    xwayland = {
      enable = true;
    };
  };

  # AMD GPU driver issue temporary workaround
  # environment.sessionVariables.WLR_NO_HARDWARE_CURSORS = "1";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${current.user} = {
    extraGroups = [ "wheel" "networkmanager" "input" "video" "libvirtd" "vboxusers" ];
    isNormalUser = true;
  };

  # Just the bear necessities...
  environment.systemPackages = with pkgs; [
    coreutils
    pciutils
    usbutils
    dmidecode
    killall
    unzip
    wget
    dig
    #libsForQt5.qt5.qtgraphicaleffects
  ];

  # Wayland
  qt = {
    enable = true;
    platformTheme = "lxqt";
  };

  services.dbus.enable = true;

  # Fonts
  fonts = {
    enableDefaultPackages = true;
    fontconfig = {
      defaultFonts = {
        serif = [ "Noto Sans Display" ];
        sansSerif = [ "Noto Sans Display" ];
        monospace = [ "Courier Prime Code" ];
      };
    };
  };

  # VM
  programs.dconf.enable = true;
  virtualisation.libvirtd.enable = true;

  # Security
  services.logind.extraConfig = ''
    HandlePowerKey=suspend
  '';
  
  #security.pam.services.swaylock.text = ''
  #  # Account management.
  #  account required pam_unix.so

  #  # Authentication management.
  #  auth sufficient pam_unix.so   likeauth try_first_pass
  #  auth required pam_deny.so

  #  # Password management.
  #  password sufficient pam_unix.so nullok sha512

  #  # Session management.
  #  session required pam_env.so conffile=/etc/pam/environment readenv=0
  #  session required pam_unix.so
  #'';

  # List services that you want to enable:
  services.udisks2.enable = true;
  services.gvfs.enable = true;
  
  # Open ports in the firewall.
  networking.firewall = {
    enable = true;
  #  trustedInterfaces = [ ];
  #  allowedUDPPorts = [ ];
  };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # Let 'nixos-version --json' know about the Git revision
  # of this flake.
  system.configurationRevision = inputs.nixpkgs.lib.mkIf (inputs.self ? rev) inputs.self.rev;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}

