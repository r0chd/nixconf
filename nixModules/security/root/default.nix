{ lib, config, ... }:
{
  options.root = {
    auth = {
      password = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
      rootPw = lib.mkEnableOption "Root password";
    };
    timeout = lib.mkOption {
      type = lib.types.int;
      default = 15;
    };
  };

  config.security.sudo = {
    execWheelOnly = true;
    extraConfig =
      ''
        Defaults timestamp_timeout=${toString config.root.timeout}
      ''
      + lib.optionalString (config.root.auth.rootPw) ''
        Defaults rootpw
      '';
  };
}
