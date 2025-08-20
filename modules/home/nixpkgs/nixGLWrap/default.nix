# Helper for wrapping packages with nixGL
#
# Usage:
# nixpkgs.config.nixGLWrap = [ "package1" "package2" ];
{
  lib,
  config,
  inputs,
  ...
}:
let
  # Not possible to set options for nixpkgs.config
  # and I REALLY love this syntax so yeah
  cfg = config.nixpkgs.config.nixGLWrap or [ ];
in
{
  nixGL.packages = inputs.nixGL.packages;

  nixpkgs.overlays = [
    (
      _: prev:
      let
        wrapAttrs = lib.listToAttrs (
          cfg
          |> lib.map (name: {
            name = name;
            value = prev.${name};
          })
        );
      in
      lib.attrsets.mapAttrs (_: pkg: config.lib.nixGL.wrap pkg) wrapAttrs
    )

  ];
}
