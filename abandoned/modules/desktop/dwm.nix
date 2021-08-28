{ pkgs, ... }:

let dwm-flexipatch = pkgs.fetchFromGitHub {
      owner = "bakkeby";
      repo = "dwm-flexipatch";
      rev = "c2e4fed9182c84c713b24e6f3c60754c950bcf9b";
      sha256 = "0iyv5sdjw7kvksmndv8m04wszaxpcyxvpf8m2g4rbzz18almq63c";
    };
    patches = [ "BAR_ANYBAR_PATCH" ];

in {
  nixpkgs.overlays = [
    (final: prev: {
      dwm = prev.dwm.overrideAttrs (oldAttrs: rec {
#        patches = [
#          (prev.fetchpatch {
#            url = "https://dwm.suckless.org/patches/gaplessgrid/dwm-gaplessgrid-20160731-56a31dc.diff";
#            sha256 = "1a1z6byqv6q958p6bk08x66jq4bkl4p9b9vnkh4l6fx5i84b0wd9";
#          })
#          (prev.fetchpatch {
#            url = "https://github.com/mihirlad55/dwm-anybar/releases/download/v1.1.1/dwm-anybar-polybar-tray-fix-20200905-bb2e722.diff";
#            sha256 = "1sba2y9lgnhpfbj3xy807ihbxak8z2nq0asg7bfbi3mgxplj5ygz";
#          })
#        ];
        #configFile = prev.writeText "config.h" (builtins.readFile ../../config/dwm/config.def.h);
        #postPatch = oldAttrs.postPatch or "" + "\necho 'Using own config file...'\n cp ${configFile} config.def.h";
        src = dwm-flexipatch;
        postPatch = oldAttrs.postPatch or "" + ''
          echo 'Editing patches.def.h ...'
          ${builtins.concatStringsSep "\n" (map (patch: ''sed -i "s/#define ${patch} 0/#define ${patch} 1/" patches.def.h'') patches)}
        '';
      });
    })
  ];

  xsession = {
    enable = true;
    windowManager.command = ''
      "${pkgs.dwm}/bin/dwm"
    '';
  };
}
