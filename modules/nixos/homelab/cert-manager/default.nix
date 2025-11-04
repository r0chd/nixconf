{ ... }:
{
  imports = [
    ./service-account.nix
    ./namespace.nix
    ./cluster-role-binding.nix
    ./validating-webhook-configuration.nix
    ./mutating-webhook-configuration.nix
    ./deployment.nix
    ./role.nix
    ./service.nix
    ./cluster-role.nix
    ./crd.nix
    ./role-binding.nix
    ./self-signed-issuer.nix
    ./cluster-issuer.nix
  ];
}
