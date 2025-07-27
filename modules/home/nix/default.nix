{ inputs, pkgs, ... }:
{
  imports = [ ./access-tokens ];

  #nix.settings = {
  #  substituters = [ "https://cache.garnix.io" ];
  #  trusted-substituters = [ "https://cache.garnix.io" ];
  #  trusted-public-keys = [ "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g=" ];
  #};

  nix = {
    package = pkgs.nix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
        "pipe-operators"
      ];
      substituters = [ "https://nixpkgs-wayland.cachix.org" ];
      trusted-substituters = [ "https://nixpkgs-wayland.cachix.org" ];
      trusted-public-keys = [
        "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
      ];
      trusted-users = [
        "root"
        "@wheel"
      ];
      allowed-users = [
        "root"
        "@wheel"
      ];
    };

    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
    registry.nixpkgs.flake = inputs.nixpkgs;
  };
}
