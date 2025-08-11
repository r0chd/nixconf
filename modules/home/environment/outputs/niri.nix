{ config, lib, ... }:
{
  programs.niri.settings.outputs = lib.mapAttrs (_name: value: {
    inherit (value) scale;
    mode = {
      inherit (value.dimensions) width;
      inherit (value.dimensions) height;
      inherit (value) refresh;
    };
    inherit (value) position;
  }) config.environment.outputs;

}
