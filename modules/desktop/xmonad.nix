{ pkgs, ... }:

{
  xsession = {
    enable = true;
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      config = ../../config/xmonad/xmonad.hs;
    };
  };

  home.packages = with pkgs; [
    (pkgs.writers.writeHaskellBin "xmonadctl" {
      libraries = [ haskellPackages.xmonad-contrib haskellPackages.X11 ];
    } (builtins.readFile ../../config/xmonad/xmonadctl.hs))
  ];

  services.sxhkd = {
    keybindings = {
      # quit/restart xmonad
      "super + alt + {q,r}" = "xmonadctl {quit,restart}";
      # close window
      "super + q" = "xmonadctl kill-window";
      # focus or send to the given workspace
      "super + {_,shift + }{1-9}" = "xmonadctl {focus-workspace-,send-to-workspace-}{1-9}";
      # focus or swap windows
      "super + {_,shift + }{h,j,k,l}" = "xmonadctl {focus,swap}-window-{left,down,up,right}";
      # increase/decrease windows in master pane
      "super + {plus,minus}" = "xmonadctl {inc,dec}-master-windows";
      # resize windows
      "super + ctrl + {h,j,k,l}" = "xmonadctl {h-shrink,v-shrink,v-expand,h-expand}";
      # window states
      "super + t" = "xmonadctl tile-window";
    };
  };
}
