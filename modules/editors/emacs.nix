{ config, inputs, lib, pkgs, ... } :

{
  home.packages = with pkgs; [
    binutils
    git
    emacs
 #   emacsPgtkGcc
    (ripgrep.override {withPCRE2 = true;})
    gnutls
    fd
    imagemagick
    zstd
    emacs-all-the-icons-fonts
    nixfmt
  ];

  xdg.configFile."doom" = {
    source = ../../config/doom.d;
  };

#  xdg.configFile."doom" = {
#    source = ../../config/doom.d;
#    onChange = "${pkgs.writeShellScript "doom-change" ''
#      if [ ! -d "${config.xdg.configHome}/emacs" ]; then
#        git clone --progress --depth 1 https://github.com/hlissner/doom-emacs ${config.xdg.configHome}/emacs
#      fi
#    ''}";
#  };

  #home.activation = {
  #  doomEmacs = lib.hm.dag.entryAfter ["writeBoundary"] ''
  #    set -x
  #    echo hello
 ##     if [ ! -d "${config.xdg.configHome}/emacs" ]; then
 ##       git clone --progress --depth 1 https://github.com/hlissner/doom-emacs ${config.xdg.configHome}/emacs
 ##     fi
  #  '';
  #};

  services.emacs = {
    enable = true;
#    package = pkgs.emacsPgtkGcc;
  };

  services.sxhkd = {
    keybindings = {
      "super + e" = "emacsclient -c";
    };
  };
}
