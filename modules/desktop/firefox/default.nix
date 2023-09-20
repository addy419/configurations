{ inputs, config, pkgs, lib, buildFirefoxXpiAddon, ... }:

let
  myconfig = ''
    user_pref("keyword.enabled", true);
    user_pref("privacy.clearOnShutdown.cookies", false);
    user_pref("privacy.clearOnShutdown.history", false);
    user_pref("webgl.disabled", false);

    user_pref("media.ffmpeg.vaapi.enabled", true);
    user_pref("media.ffvpx.enabled", false);
    user_pref("media.rdd-vpx.enabled", false);
    user_pref("media.navigator.mediadatadecoder_vpx_enabled", true);

    user_pref("gfx.webrender.all", true);
  '';
  firefox-package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
    extraNativeMessagingHosts = [ (pkgs.callPackage ./firefox-profile-switcher-connector.nix { }) ];
    extraPolicies = { ExtensionSettings = { }; };
  };
  addons = builtins.removeAttrs (pkgs.callPackage ./addons.nix {
    inherit (config.nur.repos.rycee.firefox-addons) buildFirefoxXpiAddon;
  }) [ "override" "overrideDerivation" ];
in {
  imports = [ inputs.nur.nixosModules.nur ];

  programs.firefox = {
    enable = true;
    package = firefox-package;
    profiles = {
      hardened = {
        isDefault = true;
        search = {
          default = "DuckDuckGo";
          force = true;
        };
        extensions = builtins.attrValues addons;
        extraConfig = builtins.readFile "${inputs.hardened-firefox}/user.js"
          + myconfig;
      };
      relaxed = {
        id = 1;
        isDefault = false;
        search = {
          default = "DuckDuckGo";
          force = true;
        };
        extensions = builtins.attrValues addons;
      };
    };
  };

  xdg.configFile = {
    "firefoxprofileswitcher/config.json".text = ''
      {"browser_binary": "${firefox-package}/bin/firefox"}
    '';
  };

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    MOZ_USE_XINPUT2 = "1";
  };
}
