{ lib, config, ... }:
let
  cfg = config.security.root;
in
{
  options.security.root = {
    timeout = lib.mkOption {
      type = lib.types.int;
      default = 15;
    };
  };

  config = {
    security.sudo = {
      enable = true;
      execWheelOnly = true;
      extraConfig = ''
        Defaults timestamp_timeout=${toString cfg.timeout}
      '';
    };
  };
}
