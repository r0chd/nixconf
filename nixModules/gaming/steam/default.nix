{ config, lib, ... }:
let cfg = config.gaming;
in {
  config = lib.mkIf cfg.steam.enable {
    programs.steam.enable = true;

    impermanence.persist-home.directories = [
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
