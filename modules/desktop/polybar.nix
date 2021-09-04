{ pkgs, ... }:

{
  home.packages = with pkgs; [
    font-awesome
  ];

  services.polybar = {
    enable = true;
    script = "";
    #script = "polybar main 2>/home/aditya/.polybar.log &";
    settings = {
      "colors" = {
        # Colors are provided through Xresources. see: github.com/dracula/xresources
        background = "\${xrdb:background}";
        foreground = "\${xrdb:foreground}";
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
        bottom = true;
        modules = {
          left = "i3 bspwm ewmh";
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
    };
  };
}
