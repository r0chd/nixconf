{ lib, ... }:
let
  inherit (lib) types;
in
{
  imports = [
    ./discord-provider.nix
    ./kustomization.nix
    ./bucket.nix
  ];

  options.homelab.flux = {
    endpoint = lib.mkOption {
      type = types.str;
    };
    webhook = lib.mkOption {
      type = types.nullOr types.str;
      default = null;
    };
  };
}
