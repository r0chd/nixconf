{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.ladybird;
in
{
  options.programs.ladybird.enable = lib.mkEnableOption "ladybird";

  config = lib.mkIf cfg.enable {
    home = {
      packages = [ pkgs.ladybird ];
      shellAliases.ladybird = "Ladybird";
    };
  };
}
