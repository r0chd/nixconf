{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.homelab.system.cloudnative-pg;
  inherit (lib) types;
in
{
  options.homelab.system.cloudnative-pg = {
    enable = lib.mkOption {
      type = types.bool;
      default = true;
    };
  };

  config.services.k3s.manifests.cnpg = {
    inherit (cfg) enable;
    source = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/cloudnative-pg/cloudnative-pg/v1.24.4/releases/cnpg-1.24.4.yaml";
      sha256 = "1pg00s18gxxn9asxskgdg13yar1c96dd4zjzmm3932aimp334knd";
    };
  };
}
