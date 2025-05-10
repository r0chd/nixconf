{
  config,
  lib,
  system_type,
  ...
}:
let
  cfg = config.environment.wallpaper;
in
{
  options.environment.wallpaper = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = system_type == "desktop";
    };
  };

  config = {
    services.moxpaper = { inherit (cfg) enable; };
    home.persist.directories = [ ".cache/moxpaper" ];
  };
}
