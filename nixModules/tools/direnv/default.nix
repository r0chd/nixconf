{ conf, lib, std }:
let inherit (conf) username;
in {
  options.direnv.enable = lib.mkEnableOption "Enable direnv";

  config = lib.mkIf conf.direnv.enable {
    home-manager.users."${username}" = {
      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
      home.persistence.${std.dirs.home-persist}.directories =
        lib.mkIf conf.impermanence.enable [
          ".local/share/direnv"
          ".cache/nix"
        ];
    };
  };
}
