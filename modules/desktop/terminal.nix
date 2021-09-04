{ pkgs, ... }: 

let wcwidth-icons = with pkgs; stdenv.mkDerivation rec {
  name = "wcwidth-icons-${version}";
  src = fetchurl {
     url = "https://github.com/powerman/wcwidth-icons/archive/refs/tags/v${version}.tar.gz";
     sha256 = "1j87159859mwsdvi12gal6l81jivy4pjk62f4h016wmv866ybphf";
  };
  version = "0.2.2";
  installFlags = [ "LIBDIR=$(out)/lib" ];
};

in {
  home.packages = with pkgs; [
    wcwidth-icons
  ];

  programs.urxvt = {
    enable = true;
    iso14755 = false;
    fonts = [ "xft:Courier Prime Code:size=13" "xft:Iosevka Nerd Font:size=13" ];
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

  services.sxhkd = {
	  keybindings = {
  	  # terminal emulator
  	  "super + Return" = "LD_PRELOAD=${wcwidth-icons}/lib/libwcwidth-icons.so urxvt";
	  };
  };

  xsession = {
    windowManager.qtile = {
      terminal = "urxvt";
      # TODO: 0.18.0 has support for spawncmd which can LD_PRELOAD
      keybindings = {
        "mod + Return" = "lazy.spawn(terminal)";
        "mod + t" = ''lazy.spawn("LD_PRELOAD=${wcwidth-icons}/lib/libwcwidth-icons.so urxvt",shell=True)'';
      };
    };
  };
}
