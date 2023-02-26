{ pkgs, ... }:

let nwg-look = with pkgs; stdenv.mkDerivation rec {
  name = "nwg-look-${version}";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner  = "nwg-piotr";
    repo   = "nwg-look";
    rev    = "9bb91da211c5d494e755cf9715938d68a0d00c6a";
    sha256 = "0x19893377j02dl6mfw1ydpnbmw7wzfw7hfh1yjhjrwv61svkgw9";
  };

  buildInputs = [ go ];
  nativeBuildInputs = [ gtk3 xcur2png glib cairo ];
  #configurePhase = "";
  #buildPhase = "make build";
  #installPhase = "make install";
  installFlags = [ "DESTDIR=$(out)" ];
};

in {
  home.packages = [ nwg-look ];
}

#{ lib
#, stdenv
#, fetchurl
#, gtk3
#, xcur2png
#, glib
#, cairo
#}:
#
#stdenv.mkDerivation rec {
#  pname = "nwg-look";
#  version = "0.1.4";
#
#  src = fetchurl {
#    url = "https://github.com/nwg-piotr/nwg-look/releases/download/v${version}/${pname}-v${version}_x86_64.tar.gz";
#    sha256 = "1bvy972c29hxwnrrfahzbw484sb52219699jvnj5nb7bngyw5x5a";
#  };
#}
#
