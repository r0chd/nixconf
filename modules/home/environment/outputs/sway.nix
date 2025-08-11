{ config, lib, ... }:
let
  cfg = config.environment.outputs;
in
{
  wayland.windowManager.sway.config.output =
    cfg
    |> lib.mapAttrs (
      _name: value: {
        position = "${toString value.position.x} ${toString value.position.y}";
        resolution = "${toString value.dimensions.width}x${toString value.dimensions.height}@${toString value.refresh}Hz";
        scale = "${toString value.scale}";
      }
    );
}
