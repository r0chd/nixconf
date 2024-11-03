{ config, lib, std, username, ... }: {
  options.direnv.enable = lib.mkEnableOption "Enable direnv";

  config = lib.mkIf config.direnv.enable {
    home-manager.users."${username}" = {
      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
      home.persistence.${std.dirs.home-persist}.directories =
        lib.mkIf config.impermanence.enable [
          ".local/share/direnv"
          ".cache/nix"
        ];
    };
  };
}
