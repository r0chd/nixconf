{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.browser;
in
{
  config = lib.mkIf (cfg.enable && cfg.variant == "ladybird") {
    home = {
      packages = with pkgs; [ ladybird ];
      shellAliases.ladybird = "Ladybird";
    };
  };
}
