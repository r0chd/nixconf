{ config, lib, ... }:
{
  imports = [
    ./clusterrole.nix
    ./clusterrolebinding.nix
    ./deployment.nix
    ./mutating-webhook.nix
    ./serviceaccount.nix
    ./service.nix
  ];
}
