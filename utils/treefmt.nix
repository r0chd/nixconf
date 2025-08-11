{ inputs, pkgs, ... }:
{
  projectRootFile = "flake.nix";

  settings.on-unmatched = "info";

  programs = {
    nixfmt = {
      enable = true;
      strict = true;
    };
    deadnix.enable = true;
    statix = {
      enable = true;
      package = inputs.statix.packages.${pkgs.system}.default;
    };
  };
}
