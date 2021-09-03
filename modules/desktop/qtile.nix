{ lib, ... }:

{
  xsession = {
    enable = true;
    windowManager.qtile = {
      enable = true;
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
        "mod + r" = {
          keybindings = {
            "h" = "lazy.function(shrink_master)";
            "l" = "lazy.function(grow_master)";
            "mod + r" = {
              keybindings = {
                "h" = "lazy.function(shrink_master)";
                "l" = "lazy.function(grow_master)";
              };
            };
          };
          mode = "resize";
        };
      };
      groups = (lib.genList (i: toString(i + 1)) 9);
      layouts = [ "MonadTall()" ];
      extraConfig = ''
        from typing import List  # noqa: F401
        from libqtile import bar, layout, widget, hook
        from libqtile.config import Click, Drag, Group, Key, Screen, KeyChord
        from libqtile.lazy import lazy
        from libqtile.utils import guess_terminal

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
}

