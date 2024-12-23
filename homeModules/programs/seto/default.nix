{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:
let
  cfg = config.programs.seto;
in
{
  imports = [
    inputs.seto.homeManagerModules.default
    inputs.seto.homeManagerModules.stylix
  ];

  home.packages = lib.mkIf cfg.enable [ pkgs.grim ];
  programs.seto = {
    package = inputs.seto.packages.${pkgs.system}.default;
    font.size = lib.mkForce "20";
  };
}
