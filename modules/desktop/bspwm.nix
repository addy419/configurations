{ pkgs, config, ... }:

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
        automatic_scheme = "alternate";
        # Dracula colorscheme #NotSureIfThisGoesInXresources
        normal_border_color = "#44475a";
        active_border_color = "#bd93f9";
        focused_border_color = "#ff79c6";
        presel_feedback_color = "#6272a4";
        external_rules_command = "${config.xdg.configHome}/bspwm/external_rules";
      };
      rules = {
        "Emacs" = {
          state = "tiled";
        };
      };
    };
  };

  services.sxhkd = {
    keybindings = {
      # quit/restart bspwm
      "super + alt + {q,r}" = "bspc {quit,wm -r}";
      # close and kill
      "super + {_,shift + }q" = "bspc node -{c,k}";
      # focus or send to the given desktop
      "super + {_,shift + }{1-9}" = "bspc {desktop -f,node -d} '^{1-9}'";
      # focus and swap windows
      "super + {_,shift + }{h,j,k,l}" = "bspc node -{f,s} {west,south,north,east}";
      # special case: rec
      "super + ctrl + {h,j,k,l}" = "bspc node -p {west,south,north,east} -i";
      # move focused window to rec
      "super + ctrl + i" = "bspc node @ -n $(bspc query -N -n pointed.leaf.\\!window.local || bspc query -N -n next.leaf.\\!window.local)";
      # remove empty rec in current workspace
      "super + ctrl + q" = "for win in $(bspc query -N -n .leaf.\!window.local) ; do bspc node $win -k ; done;";
    };
  };

  services.polybar = {
    settings = {
      "colors" = {
        urgent = "\${xrdb:color1}";
        empty = "#44475a";
      };
      "bar/main" = {
        wm-restack = "bspwm";
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

  home.packages = with pkgs; [
    picom
  ];
}
