{ conf, lib, std }:
let inherit (conf) username;
in {
  options.bat.enable = lib.mkEnableOption "Enable bat";

  config = lib.mkIf conf.bat.enable {
    environment.shellAliases.cat = "bat";
    home-manager.users."${username}" = {
      programs.bat = { enable = true; };

      home.persistence.${std.dirs.home-persist}.directories =
        lib.mkIf conf.impermanence.enable [ ".cache/bat" ];
    };

  };
}
