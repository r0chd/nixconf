{ pkgs, ... }:
{
  imports = [ ./policies ];

  config.services.k3s.manifests.kyverno.source = pkgs.fetchurl {
    url = "https://github.com/kyverno/kyverno/releases/download/v1.16.2/install.yaml";
    sha256 = "sha256-g+FuynzqsKm2MVduSUs4yqmg5C9lrkFU8lZrSd72F4k=";
  };
}
