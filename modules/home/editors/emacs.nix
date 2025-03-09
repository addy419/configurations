{ config, inputs, lib, pkgs, ... } :

{
  home.packages = with pkgs; [
    binutils
    emacs29-pgtk
    (ripgrep.override {withPCRE2 = true;})
    gnutls
    fd
    imagemagick
    zstd
    nixfmt-rfc-style
  ];

  xdg.configFile."doom" = {
    source = ../../../config/doom.d;
  };

  home.sessionPath = [ "${config.home.homeDirectory}/.config/emacs/bin" ];

  # services.emacs = {
  #   enable = true;
  #   package = pkgs.emacs29-pgtk;
  # };

  services.sxhkd = {
    keybindings = {
      "super + e" = "emacsclient -c";
    };
  };
}
