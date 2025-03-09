{ pkgs, ... }:

{
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-vkcapture
      obs-backgroundremoval
      obs-vaapi
      obs-gstreamer
      obs-replay-source
      obs-pipewire-audio-capture
      obs-source-clone
    ];
  };
}
