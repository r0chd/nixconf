{ inputs, lib, ... }:
{
  # Fully disable channels
  #nix = {
  #  channel.enable = false;
  #  registry = lib.mapAttrs (_: flake: { inherit flake; }) inputs;
  #  nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") inputs;
  #  settings = {
  #    nix-path = lib.mapAttrsToList (n: _: "${n}=flake:${n}") inputs;
  #    flake-registry = "";
  #  };
  #};

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
        "pipe-operators"
      ];
      auto-optimise-store = true;
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
  };
}
