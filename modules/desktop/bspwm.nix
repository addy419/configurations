{ pkgs, ... }:

{
  xsession = {
    enable = true;
    windowManager.bspwm = {
      enable = true;
      # For only single monitor setups
      monitors = { "$(xrandr --listactivemonitors | awk '{getline; print $4}')" = [ "1" "2" "3" "4" "5" "6" "7" "8" "9" ]; };
      settings = {
        border_width = 1;
        window_gap = 12;
        split_ratio = 0.50;
        borderless_monocle = true;
        gapless_monocle = true;
        # Dracula colorscheme #NotSureIfThisGoesInXresources
        normal_border_color = "#44475a";
        active_border_color = "#bd93f9";
        focused_border_color = "#ff79c6";
        presel_feedback_color = "#6272a4";

      };
      rules = {
        "Emacs" = {
          state = "tiled";
        };
      };
    };
  };

  services.sxhkd = {
    enable = true;
    keybindings = {
      # quit/restart bspwm
      "super + alt + {q,r}" = "bspc {quit,wm -r}";
      # close and kill
      "super + {_,shift + }q" = "bspc node -{c,k}";
      # focus or send to the given desktop
      "super + {_,shift + }{1-9}" = "bspc {desktop -f,node -d} '^{1-9}'";
    };
  };

  home.packages = with pkgs; [
    unstable.bsp-layout
    picom
  ];
}
