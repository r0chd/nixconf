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
  cfg = config.nixpkgs.config.nixGLWrap;
in
{
  nixGL.packages = inputs.nixGL.packages;

  nixpkgs.overlays = [
    (
      final: prev:
      with prev;
      builtins.listToAttrs (
        cfg
        |> lib.map (value: {
          name = value;
          value = (config.lib.nixGL.wrap prev.${value});
        })
      )
    )
  ];
}
