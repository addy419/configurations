{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user.name = "Aditya Sadawarte";
      user.email = "adityasadawarte01@gmail.com";
      merge.tool = "meld";
    };
  };

  home.packages = with pkgs; [
    meld
  ];
}
