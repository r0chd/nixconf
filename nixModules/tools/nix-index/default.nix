{ lib, config, username, ... }: {
  options.nix-index.enable = lib.mkEnableOption "Enable nix-index";

  config = lib.mkIf config.nix-index.enable {
    home-manager.users.${username}.programs.nix-index.enable = true;

    impermanence.persist-home.directories = [ ".cache/nix-index" ];
  };
}
