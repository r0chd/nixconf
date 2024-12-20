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
  options.programs.discord.enable = lib.mkEnableOption "discord";

  config = lib.mkIf config.programs.discord.enable {
    home.packages = with pkgs; [ discord-canary ];

    impermanence.persist.directories = [ ".config/discordcanary" ];
  };
}
