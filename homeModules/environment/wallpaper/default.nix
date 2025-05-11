{
  config,
  lib,
  system_type,
  inputs,
  ...
}:
let
  cfg = config.environment.wallpaper;
in
{
  imports = [
    inputs.moxpaper.homeManagerModules.default
    inputs.moxpaper.homeManagerModules.stylix
  ];

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
