{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.discord;
in
{
  options.programs.discord = {
    enable = lib.mkEnableOption "discord";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.discord;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];

    impermanence.persist.directories = [
      ".config/discordcanary"
      ".config/discord"
    ];
  };
}
