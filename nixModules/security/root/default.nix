{ lib, config, ... }:
let
  cfg = config.security.root;
in
{
  options.security.root = {
    auth = {
      rootPw = lib.mkEnableOption "Root password";
    };
    timeout = lib.mkOption {
      type = lib.types.int;
      default = 15;
    };
  };

  config = {
    security.sudo = {
      enable = true;
      execWheelOnly = true;
      extraConfig =
        ''
          Defaults timestamp_timeout=${toString cfg.timeout}
        ''
        + lib.optionalString (cfg.auth.rootPw) ''
          Defaults rootpw
        '';
    };
  };
}
