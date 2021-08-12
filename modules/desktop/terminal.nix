{ pkgs, ... }: 

let wcwidth-icons = with pkgs; stdenv.mkDerivation rec {
      src = fetchurl {
            url = "https://github.com/powerman/wcwidth-icons/archive/refs/tags/v${version}.tar.gz";
            sha256 = "1j87159859mwsdvi12gal6l81jivy4pjk62f4h016wmv866ybphf";
      };
      version = "0.2.2";
      installFlags = [ "LIBDIR=$(out)/lib" ];
#      buildInputs = [ gnumake ];
};

in {
#{
      home.packages = with pkgs; [
            alacritty
            wcwidth-icons
      ];

      programs.urxvt = {
            enable = true;
            iso14755 = false;
            fonts = [ "xft:Courier Prime Code:size=12" "xft:Iosevka Nerd Font Mono" ];
            extraConfig = {
                  intensityStyles = false;
                  cursorBlink = true;
                  perl-ext-common = "default,font-size";
                  perl-lib = "${pkgs.rxvt-unicode}/lib/urxvt/perl";
            };
            keybindings = {
                  "Shift-Control-plus" = "font-size:increase";
                  "Control-minus" = "font-size:decrease";
                  "Control-0" = "font-size:reset";
                  "Shift-Control-C" = "eval:selection_to_clipboard";
                  "Shift-Control-V" = "eval:paste_clipboard";
            };
            scroll.bar = {
                  enable = true;
                  position = "right";
            };
      };
}
