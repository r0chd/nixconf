{ lib, ... }:
{
  options.root = {
    passwordAuthentication = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
  };

  config.security.sudo = {
    enable = true;
    execWheelOnly = true;
    extraConfig = ''
      Defaults rootpw
      Defaults timestamp_timeout=0
    '';
  };
}
