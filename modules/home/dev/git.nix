{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "Aditya Sadawarte";
    userEmail = "adityasadawarte01@gmail.com";
    extraConfig = {
      merge.tool = "meld";
    };
  };

  home.packages = with pkgs; [
    meld
  ];
}
