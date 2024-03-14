{ pkgs, lib, ... }:

let
  theme = pkgs.fetchFromGitHub {
    owner = "dracula";
    repo = "alacritty";
    rev = "9ae0fdedd423803f0401f6e7a23cd2bb88c175b2";
    sha256 = "sha256-MgRH5Lc8wyZ6AQZweyL1QzO5eBzVdjbOPQeRs/Mf51M=";
  };

in {
  programs.alacritty = {
    enable = true;
    settings = {
      import = [ "${theme}/dracula.toml" ];
      font = {
        normal = {
          family = "Courier Prime Code";
          style = "Regular";
        };
        italic = {
          family = "Courier Prime Code";
          style = "Italic";
        };
        bold = { family = "Courier Prime Code"; };
        bold_italic = { family = "Courier Prime Code"; };
        size = 13;
      };
    };
  };
}
