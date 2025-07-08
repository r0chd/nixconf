{ config, lib, ... }:
let
  cfg = config.environment.outputs;
in
{
  wayland.windowManager.hyprland.settings.input.monitor =
    cfg
    |> lib.mapAttrsToList (
      name: value:
      "${name}, ${toString value.dimensions.width}x${toString value.dimensions.height}@${toString value.refresh}, ${toString value.position.x}x${toString value.position.y}, ${toString value.scale}"
    );

}
