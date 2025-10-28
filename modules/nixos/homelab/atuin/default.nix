{ config, lib, ... }:
let
  cfg = config.homelab.atuin;
  inherit (lib) types;
in
{
  imports = [
    ./namespace.nix
    ./deployment.nix
    ./service.nix
    ./ingress.nix
    ./pvc.nix
    ./db
  ];

  options.homelab.atuin = {
    enable = lib.mkEnableOption "atuin k3s service";

    storageSize = lib.mkOption {
      type = types.str;
      default = "1Gi";
      description = "Storage size for atuin configuration volume";
    };
  };
}
