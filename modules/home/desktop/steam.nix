{ pkgs, config, ... }:

{
  home.packages = with pkgs; [
    steamtinkerlaunch
    protonup-qt
    # Stardew Mods
    unixtools.xxd
    xorg.xwininfo
    xdotool
    xorg.xprop
    jq
    p7zip
    xorg.xrandr
    yad
  ];

  xdg.dataFile = {
    "Steam/compatibilitytools.d/SteamTinkerLaunch/compatibilitytool.vdf".text = ''
      "compatibilitytools"
      {
        "compat_tools"
        {
          "Proton-stl" // Internal name of this tool
          {
            "install_path" "."
            "display_name" "Steam Tinker Launch"
                                                                                   
            "from_oslist"  "windows"
            "to_oslist"    "linux"
          }
        }
      }
    '';
    "Steam/compatibilitytools.d/SteamTinkerLaunch/steamtinkerlaunch".source =
      config.lib.file.mkOutOfStoreSymlink "${pkgs.steamtinkerlaunch}/bin/steamtinkerlaunch";
    "Steam/compatibilitytools.d/SteamTinkerLaunch/toolmanifest.vdf".text = ''
      "manifest"
      {
        "commandline" "/steamtinkerlaunch run"
        "commandline_waitforexitandrun" "/steamtinkerlaunch waitforexitandrun"
      }
    '';
  };
}
