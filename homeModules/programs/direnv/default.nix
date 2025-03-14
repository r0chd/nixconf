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
    programs.direnv = {
      silent = true;
      nix-direnv.enable = true;
    };
  };
}
