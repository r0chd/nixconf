{ config, lib, std, username, ... }: {
  options.bat.enable = lib.mkEnableOption "Enable bat";

  config = lib.mkIf config.bat.enable {
    environment.shellAliases.cat = "bat";
    home-manager.users."${username}" = {
      programs.bat = { enable = true; };

      home.persistence.${std.dirs.home-persist}.directories =
        lib.mkIf config.impermanence.enable [ ".cache/bat" ];
    };

  };
}
