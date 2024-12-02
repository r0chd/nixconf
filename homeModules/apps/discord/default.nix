{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.discord.enable = lib.mkEnableOption "discord";

  config = lib.mkIf config.discord.enable {
    home.packages = with pkgs; [ discord-canary ];

    impermanence.persist.directories = [ ".config/discordcanary" ];
  };
}
