{ lib, config, ... }:
let
  cfg = config.homelab.metallb;
  inherit (lib) types;
in
{
  options.homelab.metallb.addresses = lib.mkOption {
    type = types.listOf types.str;
    default = [ ];
  };

  config.services.k3s.autoDeployCharts.metallb = {
    name = "metallb";
    repo = "oci://registry-1.docker.io/bitnamicharts/metallb";
    version = "6.4.19";
    hash = "sha256-sNVVxkxvFd4Tym7KZH++geLtfWV+KDDbWVw1PKv92jw=";
    targetNamespace = "metallb-system";
    createNamespace = true;

    values = {
      global.security.allowInsecureImages = true;
      controller.image = {
        registry = "quay.io";
        repository = "metallb/controller";
        tag = "v0.14.9";
      };
      speaker.image = {
        registry = "quay.io";
        repository = "metallb/speaker";
        tag = "v0.14.9";
      };
    };

    extraDeploy = [
      {
        apiVersion = "metallb.io/v1beta1";
        kind = "IPAddressPool";
        metadata = {

          name = "k3s-nuc-pool";
          namespace = "metallb-system";
        };
        spec = { inherit (cfg) addresses; };
      }
      {
        apiVersion = "metallb.io/v1beta1";
        kind = "L2Advertisement";
        metadata = {
          name = "k3s-nuc-l2advertisment";
          namespace = "metallb-system";
        };
        spec = {
          ipAddressPools = [ "k3s-nuc-pool" ];
        };
      }
    ];
  };
}
