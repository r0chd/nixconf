{
  config,
  lib,
  ...
}:
let
  cfg = config.services.sccache;
  inherit (lib) types;
in
{
  options.services.sccache.scheduler = {
    enable = lib.mkOption {
      type = types.bool;
      default = cfg.enable;
    };
    addr = lib.mkOption {
      type = types.str;
      default = "127.0.0.1:10600";
    };
  };

  config = {
    systemd.services.sccache-scheduler = lib.mkIf cfg.scheduler.enable {
      description = "sccache-dist scheduler";
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        ExecStart = "${cfg.package}/bin/sccache-dist scheduler --config /etc/sccache/scheduler.conf";
        Restart = "on-failure";
        RestartSec = 5;
      };

      environment = {
        RUST_LOG = "info";
      };
    };

    environment = {
      etc = {
        "sccache/scheduler.conf" = {
          text = ''
            public_addr = "${cfg.scheduler.addr}"
            [client_auth]
            type = "DANGEROUSLY_INSECURE"
            [server_auth]
            type = "DANGEROUSLY_INSECURE"
          '';
          #type = "jwt_hs256"
          #secret_key = "${cfg.settings.auth.jwtSecret}"
        };
      };
    };
  };
}
