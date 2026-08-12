{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
      user.name = "Aditya Sadawarte";
      user.email = "adityasadawarte01@gmail.com";
      merge.tool = "meld";
    };
  };

  home.packages = with pkgs; [
    meld
    git-filter-repo
  ];
}
