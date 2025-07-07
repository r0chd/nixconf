{ config, lib, ... }:
let
  cfg = config.networking.wireless.iwd;
in
{
  options.networking.wireless.iwd.networks = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule { options.psk = lib.mkOption { type = lib.types.path; }; }
    );
    default = { };
  };

  config = lib.mkIf cfg.enable {
    systemd.tmpfiles.rules = lib.mkIf (cfg.networks != { }) (
      cfg.networks
      |> lib.mapAttrsToList (name: value: "L /var/lib/iwd/${name}.psk 0600 root root - ${value.psk}")
    );
  };
}
