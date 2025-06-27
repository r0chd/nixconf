{ config, lib, ... }:
let
  cfg = config.environment.outputs;
in
{
  programs.niri.settings.outputs = lib.mapAttrs (name: value: {
    inherit (value) scale;
    mode = {
      inherit (value.dimensions) width;
      inherit (value.dimensions) height;
      inherit (value) refresh;
    };
    inherit (value) position;
  }) config.environment.outputs;

}
