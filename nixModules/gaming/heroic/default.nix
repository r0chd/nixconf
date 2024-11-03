{ pkgs, config, lib, std, username, ... }:
let cfg = config.gaming;
in {
  config = lib.mkIf cfg.heroic.enable {
    environment.systemPackages = with pkgs; [ heroic ];

    home-manager.users.${username}.home.persistence.${std.dirs.home-persist}.directories =
      lib.mkIf config.impermanence.enable [ ".config/heroic" "Games/Heroic" ];
  };
}
