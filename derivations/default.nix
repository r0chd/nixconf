{ pkgs, ... }:
{
  nixpkgs.overlays = [
    (self: super: {
      swayaudioidleinhibit = pkgs.callPackage ./swayaudioidleinhibit.nix { };
    })
  ];
}
