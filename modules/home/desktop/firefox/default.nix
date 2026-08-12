{ inputs, current, pkgs, lib, buildFirefoxXpiAddon, config, ... }:

let
  myconfig = ''
    user_pref("general.autoScroll", true);
    user_pref("keyword.enabled", true);
    user_pref("browser.startup.page", 3);
    user_pref("privacy.clearOnShutdown_v2.historyFormDataAndDownloads", false);
    user_pref("privacy.clearOnShutdown_v2.browsingHistoryAndDownloads", false);
    user_pref("privacy.clearOnShutdown.cookies", false);
    user_pref("privacy.clearOnShutdown.history", false);
    user_pref("privacy.resistFingerprinting.letterboxing", false);
    user_pref("webgl.disabled", false);

    user_pref("media.ffmpeg.vaapi.enabled", true);
    user_pref("media.ffvpx.enabled", false);
    user_pref("media.rdd-vpx.enabled", false);
    user_pref("media.navigator.mediadatadecoder_vpx_enabled", true);

    user_pref("gfx.webrender.all", true);
  '';
  addons = builtins.removeAttrs (pkgs.callPackage ./addons.nix {
    #inherit (inputs.nur.legacyPackages."${current.system}".repos.rycee.firefox-addons) buildFirefoxXpiAddon;
    buildMozillaXpiAddon = inputs.nur.legacyPackages."${current.system}".repos.rycee.firefox-addons.buildFirefoxXpiAddon;
  }) [ "override" "overrideDerivation" ];
in {
  home.packages = with pkgs; [
    inputs.nur.legacyPackages."${current.system}".repos.rycee.mozilla-addons-to-nix
  ];

  programs.firefox = {
    enable = true;
    package = pkgs.firefox;
    configPath = "${config.xdg.configHome}/mozilla/firefox";
    profiles = {
      hardened = {
        isDefault = true;
        search = {
          default = "ddg";
          force = true;
        };
        extensions.packages = with inputs.nur.legacyPackages."${current.system}".repos.rycee.firefox-addons; [
         # bypass-paywalls-clean
        ] ++ (builtins.attrValues addons);
        extraConfig = builtins.readFile "${inputs.hardened-firefox}/user.js"
          + myconfig;
      };
      relaxed = {
        id = 1;
        isDefault = false;
        search = {
          default = "ddg";
          force = true;
        };
        extensions.packages = builtins.attrValues addons;
      };
    };
  };

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    MOZ_USE_XINPUT2 = "1";
  };
}
