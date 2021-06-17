{ inputs, ... }:
{
  nixpkgs.overlays = [
    inputs.emacs-overlay.overlay
    (final: prev: { unstable = inputs.nixpkgs-unstable; })
  ];
}
