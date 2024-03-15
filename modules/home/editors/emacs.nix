{ config, inputs, lib, pkgs, ... } :

{
  home.packages = with pkgs; [
    binutils
    git
    emacs-gtk
    (ripgrep.override {withPCRE2 = true;})
    gnutls
    fd
    imagemagick
    zstd
    emacs-all-the-icons-fonts
    nixfmt
  ];

  xdg.configFile."doom" = {
    source = ../../../config/doom.d;
  };

  home.sessionPath = [ "${config.home.homeDirectory}/.config/emacs/bin" ];

  services.emacs = {
    enable = true;
    package = pkgs.emacs-gtk;
  };

  services.sxhkd = {
    keybindings = {
      "super + e" = "emacsclient -c";
    };
  };
}
