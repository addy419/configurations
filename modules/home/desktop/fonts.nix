{ pkgs, ... }:

let
  courier-prime-code = pkgs.fetchFromGitHub {
    owner = "quoteunquoteapps";
    repo = "CourierPrimeCode";
    rev = "0fcb44c7bcb7e81079dfa9f0d5ac5a4b3e7bf853";
    sha256 = "0rdnnx2pdxgf3gg95wahmr7ixl09nbgngcflbplddgawa0in5fva";
  };
in {
  home.packages = with pkgs; [
    font-awesome
    #(nerdfonts.override { fonts = [ "Iosevka" "JetBrainsMono" ]; })
    noto-fonts
    fantasque-sans-mono

    vistafonts
    corefonts
    times-newer-roman
    roboto
  ];

  home.file = {
    ".local/share/fonts/courier-prime-code".source = "${courier-prime-code}/ttf";
   # ".local/share/fonts/poppins".source = poppins;
  };

  fonts.fontconfig.enable = true;

#  xdg.configFile."fontconfig/fonts.conf".text = ''
#    <?xml version="1.0"?>
#    <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
#    <fontconfig>
#    <match target="scan">
#        <test name="family">
#            <string>Courier Prime Code</string>
#        </test>
#        <edit name="spacing">
#            <int>100</int>
#        </edit>
#    </match>
#    </fontconfig>
#  '';
}
