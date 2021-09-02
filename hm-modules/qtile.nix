{ lib, pkgs, config, ... }:
with lib;

let
  cfg = config.xsession.windowManager.qtile;
  indent = (t: concatStrings (genList (i: "    ") t));
  printAttr =
    (k: set: if (hasAttr k set) then ''${k} = "${getAttr k set}"'' else "");
  parseKey = (key:
    (k:
      ''
        [${
          concatStringsSep ", " (map (s: if s == "mod" then s else ''"${s}"'')
            (sublist 0 ((length k) - 1) k))
        }], "${elemAt k ((length k) - 1)}"'')
    (splitString "+" (replaceStrings [ " " ] [ "" ] key)));
  parseKeybindings = (keys: ind:
    concatStringsSep ''
      ,
      ${indent ind}'' (map
        (k: if k == "mode" then "" else "Key(${parseKey k}, ${getAttr k keys})")
        (attrNames keys)));
  parseChords = (keys: ind:
    concatStringsSep ''
      ,
      ${indent ind}'' (map (k: ''
        KeyChord(${parseKey k}, [
        ${indent (ind + 1)}${parseKeybindings (getAttr k keys) (ind + 1)}],
        ${indent (ind + 1)}${printAttr "mode" (getAttr k keys)}
        ${indent ind})'') (attrNames keys)));
  generateGroupKeybindings = (groups:
    listToAttrs (flatten (map (g: [
      {
        name = "mod + ${g}";
        value = ''lazy.group["${g}"].toscreen()'';
      }
      {
        name = "mod + shift + ${g}";
        value = ''lazy.window.togroup("${g}", switch_group=True)'';
      }
    ]) groups)));

in {
  options.xsession.windowManager.qtile = {
    enable = mkEnableOption "qtile window manager";
    mod = mkOption {
      type = types.str;
      default = "mod4";
    };
    package = mkOption {
      type = types.package;
      default = pkgs.qtile;
    };
    extraConfig = mkOption {
      type = types.str;
      default = ''
        from typing import List  # noqa: F401
        from libqtile import bar, layout, widget
        from libqtile.config import Click, Drag, Group, Key, Screen, KeyChord
        from libqtile.lazy import lazy
        from libqtile.utils import guess_terminal
      '';
    };
    terminal = mkOption {
      type = types.str;
      default = "{guess_terminal()}";
    };
    keybindings = mkOption {
      type = types.attrsOf types.str;
      default = { };
    };
    keychords = mkOption {
      type = types.attrsOf (types.attrsOf types.str);
      default = { };
    };
    groups = mkOption {
      type = types.listOf types.str;
      default = [ "a" "s" "d" "f" "u" "i" "o" "p" ];
    };
    layouts = mkOption {
      type = types.listOf types.str;
      default = [ "Max()" "Stack(num_stacks=2)" ];
    };
    bar = {
      enable = mkOption {
        type = types.bool;
        default = true;
      };
      position = mkOption {
        type = types.str;
        default = "bottom";
      };
      config = mkOption {
        type = types.str;
        default = ''
          widget_defaults = dict(
              font='sans',
              fontsize=12,
              padding=3,
          )
          extension_defaults = widget_defaults.copy()
          statusbar = bar.Bar(
            [
                widget.CurrentLayout(),
                widget.GroupBox(),
                widget.Prompt(),
                widget.WindowName(),
                widget.Chord(
                    chords_colors={
                        'launch': ("#ff0000", "#ffffff"),
                    },
                    name_transform=lambda name: name.upper(),
                ),
                widget.TextBox("default config", name="default"),
                widget.TextBox("Press &lt;M-r&gt; to spawn", foreground="#d75f5f"),
                widget.Systray(),
                widget.Clock(format='%Y-%m-%d %a %I:%M %p'),
                widget.QuickExit(),
            ],
            24,
          )
        '';
      };
    };
    maxScreens = mkOption {
      type = types.int;
      default = 1;
    };
    append = mkOption {
      type = types.str;
      default = "";
    };
  };

  # manage qtile config
  config = mkIf cfg.enable {
    xsession = {
      windowManager.command = ''
        "${cfg.package}/bin/qtile"
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

        ${cfg.extraConfig}

        mod = "${cfg.mod}"
        terminal = f"${cfg.terminal}"

        groups = [${
          concatStringsSep ", " (map (g: ''Group("${g}")'') cfg.groups)
        }]

        # keybindings
        keys = [
            # keybindings
            ${parseKeybindings cfg.keybindings 1},
            # key chords
            ${parseChords cfg.keychords 1},
            # group keybindings
            ${parseKeybindings (generateGroupKeybindings cfg.groups) 1}
        ]

        # layouts
        layouts = [
            ${
              concatStringsSep (''
                ,
              '' + (indent 1)) (map (l: "layout.${l}") cfg.layouts)
            }
        ]

        # statusbar
        ${if cfg.bar.enable then cfg.bar.config else ""}

        # screens
        screens = [
            ${
              concatStringsSep (''
                ,
              '' + (indent 1)) (genList (i:
                "Screen(${
                  if cfg.bar.enable then
                    "${cfg.bar.position} = statusbar"
                  else
                    ""
                })") cfg.maxScreens)
            }
        ]

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
        main = None
        follow_mouse_focus = True
        bring_front_click = False
        cursor_warp = False
        floating_layout = layout.Floating(float_rules=[
            # Run the utility of `xprop` to see the wm class and name of an X client.
            {'wmclass': 'confirm'},
            {'wmclass': 'dialog'},
            {'wmclass': 'download'},
            {'wmclass': 'error'},
            {'wmclass': 'file_progress'},
            {'wmclass': 'notification'},
            {'wmclass': 'splash'},
            {'wmclass': 'toolbar'},
            {'wmclass': 'confirmreset'},  # gitk
            {'wmclass': 'makebranch'},  # gitk
            {'wmclass': 'maketag'},  # gitk
            {'wname': 'branchdialog'},  # gitk
            {'wname': 'pinentry'},  # GPG key password entry
            {'wmclass': 'ssh-askpass'},  # ssh-askpass
        ])
        auto_fullscreen = True
        focus_on_window_activation = "smart"

        # XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
        # string besides java UI toolkits; you can see several discussions on the
        # mailing lists, GitHub issues, and other WM documentation that suggest setting
        # this string if your java app doesn't work correctly. We may as well just lie
        # and say that we're a working one by default.
        #
        # We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
        # java that happens to be on java's whitelist.
        wmname = "LG3D"

        # append config
        ${cfg.append}
      '';
    };
  };
}
