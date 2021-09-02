{ lib, ... }:

{
  xsession = {
    enable = true;
    windowManager.qtile = {
      enable = true;
      keybindings = {
        "mod + mod1 + r" = "lazy.restart()";
        "mod + control + j" = "lazy.layout.shrink()";
        "mod + control + k" = "lazy.layout.grow()";
      };
      groups = (lib.genList (i: toString(i + 1)) 9);
      layouts = [ "MonadTall()" ];
    };
  };
}

