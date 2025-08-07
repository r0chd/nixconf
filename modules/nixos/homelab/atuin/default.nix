{ config, lib, ... }:
let
  cfg = config.homelab.atuin;
in
{
  imports = [
    ./deployment.nix
    ./ingress.nix
    ./pvc.nix
    ./db
  ];

  options.homelab.atuin.enable = lib.mkEnableOption "atuin k3s service";

  config.services.k3s.manifests.atuin.enable = cfg.enable && config.homelab.enable;
}
