{ lib, config, ... }:
let
  cfg = config.services.sccache;
  inherit (lib) types;
in
{
  options.services.sccache.builder = {
    enable = lib.mkOption {
      type = types.bool;
      default = cfg.enable;
    };
    addr = lib.mkOption {
      type = types.str;
      default = "127.0.0.1:10501";
    };
  };

  config = {
    systemd.services.sccache-server = lib.mkIf cfg.builder.enable {
      description = "sccache-dist server";
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        ExecStart = "${cfg.package}/bin/sccache-dist server --config /etc/sccache/server.conf";
        Restart = "on-failure";
        RestartSec = 5;
      };

      environment = {
        RUST_LOG = "info";
      };
    };

    environment.etc = {
      "sccache/server.conf" = lib.mkIf cfg.builder.enable {
        text = ''
          cache_dir = "${cfg.cacheDir}"
          public_addr = "${cfg.builder.addr}"
          scheduler_url = "${cfg.scheduler.addr}"
          [builder]
          type = "overlay"
          build_dir = "${cfg.buildDir}"
          bwrap_path = "${cfg.bwrapPackage}/bin/bwrap"
          [scheduler_auth]
          type = "DANGEROUSLY_INSECURE"
        '';
      };
      #type = "token"
      #token = "${cfg.settings.auth.token}"
    };
  };
}
