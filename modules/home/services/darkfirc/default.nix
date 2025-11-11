{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.services.darkfirc;
in
{
  options.services.darkfirc = {
    enable = lib.mkEnableOption "darkfirc";
    package = lib.mkPackageOption pkgs "darkfi" { };
    ircClientPackage = lib.mkPackageOption pkgs "weechat" { };
  };

  config = lib.mkIf cfg.enable {
    nix.settings.sandbox = "relaxed";
    home.packages = [
      cfg.package
      cfg.ircClientPackage
    ];

    systemd.user.services.darkirc = {
      Unit.After = [ "network.target" ];
      serviceConfig.ExecStart = "${cfg.package}/bin/darkirc";
      Install.WantedBy = [ "default.target" ];
    };
  };
}
