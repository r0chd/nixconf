{
  lib,
  config,
  ...
}:
let
  cfg = config.environment;
in
{
  config = lib.mkIf (cfg.session == "Wayland") {
    programs.sway = {
      enable = lib.mkDefault true;
      extraOptions = [ "--unsupported-gpu" ];
    };
  };
}
