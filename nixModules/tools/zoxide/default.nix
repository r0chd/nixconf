{ conf, lib, std }: {
  options.zoxide.enable = lib.mkEnableOption "Enable zoxide";

  config = lib.mkIf conf.zoxide.enable {
    home-manager.users."${conf.username}" = {
      programs.zoxide = {
        enable = true;
        options = [ "--cmd cd" ];
      };

      home.persistence.${std.dirs.home-persist}.directories =
        lib.mkIf conf.impermanence.enable [
          ".cache/zoxide"
          ".local/share/zoxide"
        ];
    };
  };
}
