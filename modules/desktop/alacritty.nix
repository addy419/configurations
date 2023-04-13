{ pkgs, ... }:

let
  theme = pkgs.fetchFromGitHub {
    owner = "dracula";
    repo = "alacritty";
    rev = "77aff04b9f2651eac10e5cfa80a3d85ce43e7985";
    sha256 = "1m9r1sj8wb9vasgzj4qkmj0kqprnzscb6jcdmk9qd243qv2ib6bq";
  };

in {
  programs.alacritty = {
    enable = true;
    settings = {
      import = [ "${theme}/dracula.yml" ];
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
