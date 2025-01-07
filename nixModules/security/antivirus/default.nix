{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.security.antivirus;
in
{
  options.security.antivirus.enable = lib.mkEnableOption "Enable clamav";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.clamav ];
    services.clamav = {
      daemon.enable = true;
      updater.enable = true;
    };
  };
}
