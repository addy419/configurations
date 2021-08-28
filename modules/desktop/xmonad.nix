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
    # xmonadc: client to communicate with xmonad server mode
    (pkgs.writers.writeHaskellBin "xmonadctl" {
      libraries = [ haskellPackages.xmonad-contrib haskellPackages.X11 ];
    } (builtins.readFile ../../config/xmonad/xmonadctl.hs))
  ];

  services.sxhkd = {
    keybindings = {
      # restart
      "super + alt + r" = "xmonadctl restart";
      # focus or send to the given workspace
      "super + {_,shift + }{1-9}" = "xmonadctl {focus-workspace-,send-to-workspace-}{1-9}";
    };
  };
}
