{ lib, pkgs, config, ... }:
with lib;

let
  cfg = config.xsession.windowManager.qtile;
  indent = (t: concatStrings (genList (i: "    ") t));
  parseKeybindings = (keys: ind:
    let
      parseKey = (key:
        let
          k = splitString "+" (replaceStrings [ " " ] [ "" ] key);
          last = (length k) - 1;
        in ''
          [${
            concatStringsSep ", "
            (map (s: if s == "mod" then s else ''"${s}"'') (sublist 0 last k))
          }], "${elemAt k last}"'');
      parseChord = (key: val: ind:
        let mode = if val.mode == null then "" else ''mode = "${val.mode}"'';
        in ''
          KeyChord(${parseKey key}, [
          ${indent (ind + 1)}${parseKeybindings val.keybindings (ind + 1)}],
          ${indent ind}${mode})'');
    in concatStringsSep ''
      ,
      ${indent ind}'' (map (k:
        let val = getAttr k keys;
        in if (isAttrs val) then
          (parseChord k val ind)
        else
          "Key(${parseKey k}, ${val})") (attrNames keys)));

in {
  options.xsession.windowManager.qtile = {
    enable = mkEnableOption "qtile window manager";
    mod = mkOption {
      type = types.str;
      default = "mod4";
    };
    terminal = mkOption {
      type = types.str;
      default = "{guess_terminal()}";
    };
    package = mkOption {
      type = types.package;
      default = pkgs.qtile;
    };
    extraConfig = mkOption {
      type = types.str;
      default = "";
    };
    keybindings = let
      keytype = types.attrsOf (types.either types.str chordtype);
      chordtype = types.submodule {
        options = {
          keybindings = mkOption {
            type = keytype;
            default = { };
          };
          mode = mkOption {
            type = types.nullOr types.str;
            default = null;
          };
        };
      };
    in mkOption {
      type = keytype;
      default = { };
    };
  };

  # manage qtile config
  config = mkIf cfg.enable {
    xsession = {
      windowManager.command = ''
        exec ${cfg.package}/bin/qtile start
      '';
    };

    xdg.configFile."qtile/config.py" = {
      text = ''
        # Copyright (c) 2010 Aldo Cortesi
        # Copyright (c) 2010, 2014 dequis
        # Copyright (c) 2012 Randall Ma
        # Copyright (c) 2012-2014 Tycho Andersen
        # Copyright (c) 2012 Craig Barnes
        # Copyright (c) 2013 horsik
        # Copyright (c) 2013 Tao Sauvage
        #
        # Permission is hereby granted, free of charge, to any person obtaining a copy
        # of this software and associated documentation files (the "Software"), to deal
        # in the Software without restriction, including without limitation the rights
        # to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
        # copies of the Software, and to permit persons to whom the Software is
        # furnished to do so, subject to the following conditions:
        #
        # The above copyright notice and this permission notice shall be included in
        # all copies or substantial portions of the Software.
        #
        # THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
        # IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
        # FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
        # AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
        # LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
        # OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
        # SOFTWARE.

        from typing import List  # noqa: F401
        from libqtile import bar, layout, widget
        from libqtile.config import Click, Drag, Group, Key, Match, Screen, KeyChord
        from libqtile.lazy import lazy
        from libqtile.utils import guess_terminal


        mod = "${cfg.mod}"
        terminal = f"${cfg.terminal}"

        keys = []

        # Drag floating layouts.
        mouse = [
            Drag([mod], "Button1", lazy.window.set_position_floating(),
                 start=lazy.window.get_position()),
            Drag([mod], "Button3", lazy.window.set_size_floating(),
                 start=lazy.window.get_size()),
            Click([mod], "Button2", lazy.window.bring_to_front())
        ]

        dgroups_key_binder = None
        dgroups_app_rules = []  # type: List
        follow_mouse_focus = True
        bring_front_click = False
        cursor_warp = False
        floating_layout = layout.Floating(float_rules=[
            # Run the utility of `xprop` to see the wm class and name of an X client.
            *layout.Floating.default_float_rules,
            Match(wm_class='confirmreset'),  # gitk
            Match(wm_class='makebranch'),  # gitk
            Match(wm_class='maketag'),  # gitk
            Match(wm_class='ssh-askpass'),  # ssh-askpass
            Match(title='branchdialog'),  # gitk
            Match(title='pinentry'),  # GPG key password entry
        ])

        auto_fullscreen = True
        focus_on_window_activation = "smart"
        reconfigure_screens = True

        # If things like steam games want to auto-minimize themselves when losing
        # focus, should we respect this or not?
        auto_minimize = True

        # XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
        # string besides java UI toolkits; you can see several discussions on the
        # mailing lists, GitHub issues, and other WM documentation that suggest setting
        # this string if your java app doesn't work correctly. We may as well just lie
        # and say that we're a working one by default.
        #
        # We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
        # java that happens to be on java's whitelist.
        wmname = "LG3D"

        # extra config
        ${cfg.extraConfig}
        # keybindings
        keys.extend([
            # keybindings
            ${parseKeybindings cfg.keybindings 1},
        ])
      '';
    };
  };
}
