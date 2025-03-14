{ lib, config, ... }:
let
  cfg = config.nix;
in
{
  options.nix.access-tokens = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [ ];
  };

  config.sops.templates."nix.conf" = {
    path = "/home/unixpariah/.config/nix/nix.conf";
    content = ''
      access-tokens = ${lib.concatStringsSep " " cfg.access-tokens}
    '';
  };
}
