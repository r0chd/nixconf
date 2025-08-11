{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.sccache;
  inherit (lib) types;
in
{
  options.services.sccache = {
    enable = lib.mkEnableOption "sccache";
    package = lib.mkOption {
      type = types.package;
      default = pkgs.sccache.override { distributed = true; };
      description = "sccache package with optional dist support";
    };
    bwrapPackage = lib.mkPackageOption pkgs "bubblewrap" { };

    cacheDir = lib.mkOption {
      type = types.path;
      default = "/var/lib/sccache/cache";
      description = "Directory for sccache cache";
    };

    buildDir = lib.mkOption {
      type = types.path;
      default = "/var/lib/sccache/build";
      description = "Directory for build operations";
    };

    builder = {
      enable = lib.mkOption {
        type = types.bool;
        default = cfg.enable;
      };
      addr = lib.mkOption {
        type = types.str;
        default = "127.0.0.1:10501";
      };
    };
    scheduler = {
      enable = lib.mkOption {
        type = types.bool;
        default = cfg.enable;
      };
      addr = lib.mkOption {
        type = types.str;
        default = "127.0.0.1:10600";
      };
    };

    #auth = {
    #  token = lib.mkOption {
    #    type = types.str;
    #    default = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjAsInNlcnZlcl9pZCI6IjEyNy4wLjAuMToxMDUwMSJ9.5XwRfN4GP6JjYoNq-uIv8EdJBhNa2vIJZynGbtOGD2g";
    #    description = "Authentication token (JWT format)";
    #  };

    #  jwtSecret = lib.mkOption {
    #    type = types.str;
    #    default = "f561c77ee065d64eb7c048d022b803e91ece20e12c12222be45fa9108e30944662de07b441931e2311003ac71490a061079b1614b5efa18507aaaa6f6ed3faff";
    #    description = "JWT secret key";
    #  };
    #};
  };

  config = lib.mkIf cfg.enable {
    systemd = {
      tmpfiles.rules = [
        "d ${cfg.cacheDir} 0755 root root"
        "d ${cfg.buildDir} 0755 root root"
      ];

      services.sccache-server = lib.mkIf cfg.builder.enable {
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

      services.sccache-scheduler = lib.mkIf cfg.scheduler.enable {
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
    };

    environment = {
      sessionVariables.RUSTC_WRAPPER = "${cfg.package}/bin/sccache";
      systemPackages = [ cfg.package ];
      etc = {
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
