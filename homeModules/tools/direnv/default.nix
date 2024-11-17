{ config, lib, ... }: {
  options.direnv.enable = lib.mkEnableOption "Enable direnv";

  config = lib.mkIf config.direnv.enable {
    impermanence.persist.directories = [ ".local/share/direnv" ".cache/nix" ];
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
