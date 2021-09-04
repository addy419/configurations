{ lib, pkgs, ... }:

{
  xsession = {
    enable = true;
    windowManager.qtile = {
      enable = true;
      package = pkgs.unstable.qtile;
      keybindings = {
        "mod + mod1 + r" = "lazy.restart()";
        "mod + h" = "lazy.layout.left()";
        "mod + j" = "lazy.layout.down()";
        "mod + k" = "lazy.layout.up()";
        "mod + l" = "lazy.layout.right()";
        "mod + shift + h" = "lazy.layout.swap_left()";
        "mod + shift + j" = "lazy.layout.shuffle_down()";
        "mod + shift + k" = "lazy.layout.shuffle_up()";
        "mod + shift + l" = "lazy.layout.swap_right()";
        "mod + control + h" = "lazy.function(shrink_master)";
        "mod + control + j" = "lazy.function(shrink_window)";
        "mod + control + k" = "lazy.function(grow_window)";
        "mod + control + l" = "lazy.function(grow_master)";
      };
      extraConfig = ''
        from libqtile import hook
        
        # groups
        groups = [Group(str(i+1),label="") for i in range(9)]
        for i in groups:
            keys.extend([
                Key([mod], i.name, lazy.group[i.name].toscreen(toggle=False),
                    desc="Switch to group {}".format(i.name)),
                Key([mod, "shift"], i.name, lazy.window.togroup(i.name, switch_group=True),
                    desc="Switch to & move focused window to group {}".format(i.name)),
            ])

        # layouts
        layouts = [layout.MonadTall()]

        # bar
        widget_defaults = dict(font="Iosevka Nerdfont",fontsize=12,padding=3)
        extension_defaults = widget_defaults.copy()

        workspace = widget.GroupBox(font="Font Awesome 5 Free Regular",fontsize=16,highlight_method="text")
        status_bar = bar.Bar([workspace],32)

        # screens
        maxScreens = 1
        screens = [Screen(bottom=status_bar) for i in range(maxScreens)]
        #screens = [Screen() for i in range(maxScreens)]

        def monad_stack_size(qtile):
            info = qtile.current_layout.info()
            return len(info["secondary"])

        def grow_master(qtile):
            if monad_stack_size(qtile) != 0:
                qtile.current_layout.cmd_grow_main()

        def shrink_master(qtile):
            if monad_stack_size(qtile) != 0:
                qtile.current_layout.cmd_shrink_main()

        def grow_window(qtile):
            if monad_stack_size(qtile) > 1:
                qtile.current_layout.cmd_grow()

        def shrink_window(qtile):
            if monad_stack_size(qtile) > 1:
                qtile.current_layout.cmd_shrink()

        # Reset ratio : will work in 0.18.0
        # @hook.subscribe.client_killed
        # def on_client_kill(window):
        #     if monad_stack_size(qtile) == 0:
      '';
    };
  };

  services.polybar = {
    settings = {
      "colors" = {
        urgent = "\${xrdb:color1}";
        empty = "#44475a";
      };
      "bar/main" = {
        override-redirect = false;
      };
      "module/ewmh" = {
        type = "internal/xworkspaces";
        pin-workspaces = false;
        enable-click = true;
        enable-scroll = true;
        label = {
          active = "";
          active-font = 3;
          active-padding = 1;
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

