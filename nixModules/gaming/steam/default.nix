{ config, lib, std, username, ... }:
let cfg = config.gaming;
in {
  config = lib.mkIf cfg.steam.enable {
    programs.steam.enable = true;

    home-manager.users.${username}.home.persistence.${std.dirs.home-persist}.directories =
      lib.mkIf config.impermanence.enable [
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
