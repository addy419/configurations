# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, current, config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../home-manager.nix
    ];

  # Enable flakes
  nix = {
    package = pkgs.nixUnstable;
    settings = {
      auto-optimise-store = true;
      substituters = [ "https://hyprland.cachix.org" "https://webcord.cachix.org" ];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "webcord.cachix.org-1:l555jqOZGHd2C9+vS8ccdh8FhqnGe8L78QrHNn+EFEs="
      ];
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
    package = pkgs.bluezFull;
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

  # Configure XServer
  # services.xserver = {
  #   enable = true;
  #   #desktopManager.xterm.enable = true;
  #   desktopManager.session = [{
  #     manage = "window";
  #     name = "Hyprland";
  #     start = ''
  #       Hyprland &
  #       waitPID=$!
  #     '';
  #   }];
  #   displayManager = {
  #     defaultSession = "Hyprland";
  #     lightdm.enable = true;
  #   };
  #   layout = "us";
  #   xkbVariant = "altgr-intl";
  #   xkbOptions = "caps:escape";
  #   gdk-pixbuf.modulePackages = [ pkgs.librsvg ]; # tray bugfix 
  # };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.cage}/bin/cage -s -- ${pkgs.greetd.regreet}/bin/regreet";
        #command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
        user = "greeter";
        #vt = "next";
      };
    };
  };

  environment.etc."greetd/regreet.toml".text = ''
  #background = "/usr/share/backgrounds/greeter.jpg"
  #background_fit = "Contain"
  
  [GTK]
  # Whether to use the dark theme
  application_prefer_dark_theme = true
  
  # Cursor theme name
  cursor_theme_name = "Dracula-cursors"
  
  # Font name and size
  font_name = "Noto Sans Display 16"
  
  # Icon theme name
  icon_theme_name = "Papirus"
  
  # GTK theme name
  theme_name = "Dracula"
  '';

  #environment.etc."greetd/environments".text = ''
  #  Hyprland
  #'';

  systemd.tmpfiles.rules = [
    "d /var/log/regreet 0755 greeter greeter - -"
    "d /var/cache/regreet 0755 greeter greeter - -"
  ];

  # AMD GPU driver issue temporary workaround
  # environment.sessionVariables.WLR_NO_HARDWARE_CURSORS = "1";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # PipeWire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };

  environment.etc = {
  	"wireplumber/bluetooth.lua.d/51-bluez-config.lua".text = ''
  		bluez_monitor.properties = {
  			["bluez5.enable-sbc-xq"] = true,
  			["bluez5.enable-msbc"] = true,
  			["bluez5.enable-hw-volume"] = true,
  			["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
  		}
  	'';
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${current.user} = {
    extraGroups = [ "wheel" "networkmanager" "input" "video" "libvirtd" "vboxusers" ];
    isNormalUser = true;
  };

  # Just the bear necessities...
  environment.systemPackages = with pkgs; [
    coreutils
    pciutils
    dmidecode
    killall
    unzip
    wget
#    tailscale
    #libsForQt5.qt5.qtgraphicaleffects
  ];

  # Wayland
  qt = {
    enable = true;
    platformTheme = "lxqt";
  };

  services.dbus.enable = true;

  #xdg = {
  #  portal = {
  #    enable = true;
  #    extraPortals = with pkgs; [
  #      xdg-desktop-portal-wlr
  #      xdg-desktop-portal-gtk
  #      xdg-desktop-portal-kde
  #    ];
  #    wlr.enable = true;
  #  };
  #};

  # Fonts
  fonts = {
    enableDefaultFonts = true;
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
  #virtualisation = {
    #virtualbox.host = {
    #  enable = true;
    #};
  #};

  # Security
  services.logind.extraConfig = ''
    HandlePowerKey=suspend
  '';
  
  security.pam.services.swaylock.text = ''
    # Account management.
    account required pam_unix.so

    # Authentication management.
    auth sufficient pam_unix.so   likeauth try_first_pass
    auth required pam_deny.so

    # Password management.
    password sufficient pam_unix.so nullok sha512

    # Session management.
    session required pam_env.so conffile=/etc/pam/environment readenv=0
    session required pam_unix.so
  '';

  # List services that you want to enable:
  services.udisks2.enable = true;
  services.gvfs.enable = true;
  services.fprintd.enable = true;
  # services.tailscale.enable = true;
  # services.zerotierone = {
  #   enable = true;
  #   joinNetworks = [ "abfd31bd47b97518" ];
  # };
  
  # Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  programs.gamemode.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall = {
    enable = true;
  #  checkReversePath = "loose";
  #  trustedInterfaces = [ "tailscale0" ];
  #  allowedUDPPorts = [ config.services.tailscale.port ];
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
  system.stateVersion = "22.05"; # Did you read the comment?
}

