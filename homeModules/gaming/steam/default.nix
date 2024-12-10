{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.gaming;
in
{
  config = lib.mkIf cfg.steam.enable {
    #home.packages = with pkgs; [
    #  steam
    #];

    impermanence.persist.directories = [
      {
        directory = ".steam";
        method = "symlink";
      }
      {
        directory = ".local/share/Steam";
        method = "symlink";
      }
      "Games/Steam"
    ];
  };
}
