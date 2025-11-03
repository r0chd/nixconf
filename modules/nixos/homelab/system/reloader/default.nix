{ lib, ... }:
let
  inherit (lib) types;
in
{
  imports = [
    ./serviceaccount.nix
    ./clusterrole.nix
    ./clusterrolebinding.nix
    ./deployment.nix
  ];

  options.homelab.system.reloader = {
    enable = lib.mkEnableOption "reloader";
  };
}
