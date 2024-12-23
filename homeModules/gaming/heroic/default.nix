{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.gaming.heroic;
in
{
  options.gaming.heroic.enable = lib.mkEnableOption "Enable heroic launcher";

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.heroic ];

    impermanence.persist.directories = [
      ".config/heroic"
      "Games/Heroic"
    ];
  };
}
