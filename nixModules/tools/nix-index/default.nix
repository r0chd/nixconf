{ lib, config, std, username, ... }: {
  options.nix-index.enable = lib.mkEnableOption "Enable nix-index";

  config = lib.mkIf config.nix-index.enable {
    home-manager.users.${username} = {
      programs.nix-index.enable = true;

      home.persistence.${std.dirs.home-persist}.directories =
        lib.mkIf config.impermanence.enable [ ".cache/nix-index" ];
    };
  };
}
