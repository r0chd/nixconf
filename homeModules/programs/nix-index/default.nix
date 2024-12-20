{ lib, config, ... }:
let
  cfg = config.programs.nix-index;
in
{
  config = lib.mkIf cfg.enable {
    impermanence.persist.directories = [ ".cache/nix-index" ];
  };
}
