# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../users.nix
      ../home-manager.nix
    ];

  # Enable flakes
  nix = {
    package = pkgs.nixUnstable;
    autoOptimiseStore = true;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # Enables wireless support
  networking.networkmanager.enable = true;

  # Enable bluetooth support
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";
  console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
     useXkbConfig = true; # use xkbOptions in tty.
  };

  # Configure XServer
  services.xserver = {
    enable = true;
    desktopManager.xterm.enable = true;
    displayManager.lightdm.enable = true;
    layout = "us";
    xkbVariant = "altgr-intl";
    xkbOptions = "caps:escape";
    gdk-pixbuf.modulePackages = [ pkgs.librsvg ]; # tray bugfix 
  };

  #services.greetd = {
  #  enable = true;
  #  settings = {
  #    default_session = {
  #      command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd river";
  #      user = "greeter";
  #    };
  #  };
  #};

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # PipeWire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
    media-session.config.bluez-monitor.rules = [
      {
        # Matches all cards
        matches = [ { "device.name" = "~bluez_card.*"; } ];
        actions = {
          "update-props" = {
            "bluez5.reconnect-profiles" = [ "hfp_hf" "hsp_hs" "a2dp_sink" ];
            # mSBC is not expected to work on all headset + adapter combinations.
            "bluez5.msbc-support" = true;
            # SBC-XQ is not expected to work on all headset + adapter combinations.
            "bluez5.sbc-xq-support" = true;
          };
        };
      }
      {
        matches = [
          # Matches all sources
          { "node.name" = "~bluez_input.*"; }
          # Matches all outputs
          { "node.name" = "~bluez_output.*"; }
        ];
      }
    ];
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

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.touchpad.naturalScrolling = true;

  # Just the bear necessities...
  environment.systemPackages = with pkgs; [
    coreutils
    killall
    unzip
    wget
    river
    #libsForQt5.qt5.qtgraphicaleffects
  ];

  # River dependencies
  hardware.opengl.enable = true;
  programs.xwayland.enable = true;

  # Wayland
  services.dbus.enable = true;

  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
      wlr.enable = true;
      #gtkUsePortal = true;
    };
  };

  programs.light.enable = true;

  #----=[ Fonts ]=----#
  fonts = {
    enableDefaultFonts = true;
    fontconfig = {
      defaultFonts = {
        serif = [ "Poppins" ];
        sansSerif = [ "Poppins" ];
        monospace = [ "Courier Prime Code" ];
      };
    };
  };

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
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

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

