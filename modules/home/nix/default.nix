{
  inputs,
  pkgs,
  ...
}:
{
  imports = [ ./access-tokens ];

  nix = {
    package = pkgs.nix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
        "pipe-operators"
      ];
      substituters = [
        "https://nixos-raspberrypi.cachix.org"
        "https://cache.garnix.io"
        "https://nix-community.cachix.org"
        "https://cache.nixos.org/"
      ];
      trusted-substituters = [
        "https://cache.garnix.io"
        "https://nix-community.cachix.org"
        "https://cache.nixos.org/"
      ];
      trusted-public-keys = [
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
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
