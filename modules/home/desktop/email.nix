{ pkgs, config, current, lib, ... }:

{
  programs.thunderbird = {
    enable = true;
    profiles.${current.user} = {
      isDefault = true;
    };
  };

  #accounts.email = {
  #  accounts.outlook = {
  #    realName = "Aditya Sadawarte";
  #    userName = "";
  #    primary = true;
  #    imap = {
  #      host = "outlook.office365.com";
  #      port = 993;
  #    };
  #    thunderbird = {
  #      enable = true;
  #      profiles = [ "${current.user}" ];
  #    };
  #  };
  #};

  #home.activation = {
  #  thunderbirdAction = lib.hm.dag.entryAfter ["writeBoundary"] ''
  #    outlook-secret-email=$(cat "${config.age.secrets.outlook.path}")
  #    configFile=$HOME/.thunderbird/${current.user}/user.js
  #    ${pkgs.gnused}/bin/sed -i "s#@outlook-email@#$outlook-secret-email#" "$configFile"
  #  '';
  #};

  #home.packages = with pkgs; [
  #  
  #];
}
