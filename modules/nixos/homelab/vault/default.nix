{
  lib,
  config,
  ...
}:
let
  cfg = config.homelab.vault;
  inherit (lib) types;
in
{
  imports = [
    ./namespace.nix
    ./server
    ./injector
    ./ui-service.nix
  ];

  options.homelab.vault = {
    enable = lib.mkEnableOption "vault k3s service";

    ingressHost = lib.mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Hostname for vault ingress (e.g., example.com)";
    };

  };
}
