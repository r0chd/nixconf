{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.homelab.cloudnative-pg;

  cnpgManifest = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/cloudnative-pg/cloudnative-pg/v1.24.4/releases/cnpg-1.24.4.yaml";
    sha256 = "1pg00s18gxxn9asxskgdg13yar1c96dd4zjzmm3932aimp334knd";
  };

  cnpgCrdsOnly =
    pkgs.runCommand "cnpg-crds.yaml"
      {
        buildInputs = [ pkgs.yq-go ];
      }
      ''
        ${pkgs.yq-go}/bin/yq eval-all 'select(.kind == "CustomResourceDefinition")' ${cnpgManifest} > $out
      '';
in
{
  config = lib.mkIf (config.homelab.enable && cfg.enable) {
    services.k3s.manifests.cnpg-crds = {
      enable = true;
      source = cnpgCrdsOnly;
    };
  };
}
