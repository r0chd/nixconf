{ config, lib, ... }:
let
  cfg = config.programs.direnv;
in
{
  config = lib.mkIf cfg.enable {
    home.persist.directories = [
      ".local/share/direnv"
      ".cache/nix"
    ];
    programs.direnv.nix-direnv.enable = true;
  };
}
