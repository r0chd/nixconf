{ lib, config, ... }: {
  options.nix-index.enable = lib.mkEnableOption "Enable nix-index";

  config = lib.mkIf config.nix-index.enable {
    impermanence.persist.directories = [ ".cache/nix-index" ];
    programs.nix-index.enable = true;
  };
}
