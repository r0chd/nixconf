{ config, lib, username, ... }: {
  options.direnv.enable = lib.mkEnableOption "Enable direnv";

  config = lib.mkIf config.direnv.enable {
    home-manager.users."${username}" = {
      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
    };

    impermanence.persist-home.directories =
      lib.mkIf config.impermanence.enable [
        ".local/share/direnv"
        ".cache/nix"
      ];
  };
}
