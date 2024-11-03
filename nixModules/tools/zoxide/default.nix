{ config, lib, std, username, ... }: {
  options.zoxide.enable = lib.mkEnableOption "Enable zoxide";

  config = lib.mkIf config.zoxide.enable {
    home-manager.users."${username}" = {
      programs.zoxide = {
        enable = true;
        options = [ "--cmd cd" ];
      };

      home.persistence.${std.dirs.home-persist}.directories =
        lib.mkIf config.impermanence.enable [
          ".cache/zoxide"
          ".local/share/zoxide"
        ];
    };
  };
}
