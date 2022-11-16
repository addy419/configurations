{ pkgs, ... }: 

{
  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        normal = {
          family = "Courier Prime Code";
          style = "Regular";
        };
        italic = {
          family = "Courier Prime Code";
          style = "Italic";
        };
        bold = {
          family = "Courier Prime Code";
        };
        bold_italic = {
          family = "Courier Prime Code";
        };
        size = 13;
      };
    };
  };

  services.sxhkd = {
	  keybindings = {
  	  "super + t" = "alacritty";
	  };
  };

  xsession = {
    windowManager.qtile = {
#      terminal = "alacritty";
      keybindings = {
        "mod + t" = "lazy.spawn('alacritty')";
      };
    };
  };
}
