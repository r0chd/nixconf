{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.gaming;
in
{
  config = lib.mkIf cfg.heroic.enable {
    home.packages = with pkgs; [ heroic ];

    impermanence.persist.directories = [
      ".config/heroic"
      "Games/Heroic"
    ];
  };
}
