{ pkgs, ... }:

{
  home.packages = with pkgs; [
    font-awesome
  ];

  services.polybar = {
    enable = true;
    script = "polybar main &";
    settings = {
      "colors" = {
        # Colors are provided through Xresources. see: github.com/dracula/xresources
        background = "\${xrdb:background}";
        foreground = "\${xrdb:foreground}";
        urgent = "\${xrdb:color1}";
        empty = "#44475a";
      };
      "bar/main" = {
        monitor = "\${env:MONITOR:}";
        font-0 = "Iosevka Nerd Font:pixelsize=12;3";
        font-1 = "Font Awesome 5 Free Regular:pixelsize=12;2";
        font-2 = "Font Awesome 5 Free Solid:pixelsize=12;2";
        font-3 = "Font Awesome 5 Brands:pixelsize=12;2";
        width = "100%";
        height = "32px";
        radius = 0;
        background = "\${colors.background}";
        foreground = "\${colors.foreground}";
        wm-restack = "bspwm";
        override-redirect = false;
        bottom = true;
        modules = {
          left = "bspwm";
          right = "date";
        };
        tray = {
          position = "right";
          padding = 2;
        };
      };
      "module/date" = {
        type = "internal/date";
        internal = 5;
        date = "%a %d %b";
        time = "%I:%M %p";
        label = "%date% | %time%";
      };
      "module/bspwm" = {
        type = "internal/bspwm";
        pin-workspaces = true;
        inline-mode = false;
        enable-click = true;
        enable-scroll = false;
        fuzzy-match = true;
        label = {
          focused = "";
          focused-font = 3;
          focused-padding = 1;
          occupied = "";
          occupied-font = 2;
          occupied-padding = 1;
          urgent = "";
          urgent-font = 2;
          urgent-padding = 1;
          urgent-foreground = "\${colors.urgent}";
          empty = "";
          empty-font = 2;
          empty-padding = 1;
          empty-foreground = "\${colors.empty}";
        };
      };
    };
  };
}
