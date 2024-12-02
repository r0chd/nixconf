{ lib, config, ... }:
let
  cfg = config.security.root;
in
{
  options.security.root = {
    auth = {
      passwordless = lib.mkEnableOption "Passwordless root";
      rootPw = lib.mkEnableOption "Root password";
    };
    timeout = lib.mkOption {
      type = lib.types.int;
      default = 15;
    };
  };

  config = {
    security.sudo = {
      execWheelOnly = true;
      extraConfig =
        ''
          Defaults timestamp_timeout=${toString cfg.timeout}
        ''
        + lib.optionalString (cfg.auth.rootPw) ''
          Defaults rootpw
        '';
    };

    users.users.root = {
      isNormalUser = false;
      hashedPassword = lib.mkIf (cfg.auth.passwordless) " ";
      hashedPasswordFile = lib.mkIf (!cfg.auth.passwordless) config.sops.secrets.password;
    };
  };
}
