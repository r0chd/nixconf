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
    package = lib.mkPackageOption pkgs "sccache" { };
    bwrapPackage = lib.mkPackageOption pkgs "bubblewrap" { };

    cacheDir = lib.mkOption {
      type = types.path;
      default = "/var/cache/sccache";
      description = "Directory for sccache cache";
    };

    buildDir = lib.mkOption {
      type = types.path;
      default = "/var/lib/sccache/build";
      description = "Directory for build operations";
    };

    settings = {
      builder = {
        addr = lib.mkOption {
          type = types.str;
          default = "127.0.0.1:10501";
        };
      };
      scheduler = {
        addr = lib.mkOption {
          type = types.str;
          default = "127.0.0.1:10600";
        };
      };

      auth = {
        token = lib.mkOption {
          type = types.str;
          default = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ0ZXN0In0.Hs_rWhKOBA4DbQfzh0rb_tPGvqrxJjbVZQGYV3uSsXA";
          description = "Authentication token (JWT format)";
        };

        jwtSecret = lib.mkOption {
          type = types.str;
          default = "MC4CAQAwBQYDK2VwBCIEIOz2tJcKlyL/9E96FZ8yoP9QUPLcYeHu4t/v/1WJepII";
          description = "JWT secret key";
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    boot.kernel.sysctl = {
      "kernel.unprivileged_userns_clone" = 1;
      "user.max_user_namespaces" = 3883;
    };

    systemd.tmpfiles.rules = [
      "d ${cfg.cacheDir} 0755 sccache sccache -"
      "d ${cfg.buildDir} 0755 sccache sccache -"
      "d /var/lib/sccache 0755 sccache sccache -"
    ];

    environment.etc = {
      "sccache/sccache.conf".text = ''
        cache_dir = "${cfg.cacheDir}"
        public_addr = "${cfg.settings.builder.addr}"
        scheduler_url = "${cfg.settings.scheduler.addr}"
        [builder]
        type = "overlay"
        build_dir = "${cfg.buildDir}"
        bwrap_path = "${cfg.bwrapPackage}/bin/bwrap"
        [scheduler_auth]
        type = "token"
        token = "${cfg.settings.auth.token}"
      '';

      "sccache/scheduler.conf".text = ''
        public_addr = "${cfg.settings.scheduler.addr}"
        [client_auth]
        type = "token"
        token = "${cfg.settings.auth.token}"
        [server_auth]
        type = "jwt_hs256"
        secret_key = "${cfg.settings.auth.jwtSecret}"
      '';
    };

    systemd.services.sccache-server = {
      description = "sccache-dist server";
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        ExecStart = "${cfg.package}/bin/sccache-dist server --config /etc/sccache/sccache.conf";
        Restart = "on-failure";
        RestartSec = 5;

        CapabilityBoundingSet = "CAP_SYS_ADMIN CAP_SETUID CAP_SETGID CAP_DAC_OVERRIDE CAP_CHOWN";
        AmbientCapabilities = "CAP_SYS_ADMIN CAP_SETUID CAP_SETGID CAP_DAC_OVERRIDE CAP_CHOWN";

        ReadWritePaths = [
          cfg.cacheDir
          cfg.buildDir
          "/var/lib/sccache"
        ];

        NoNewPrivileges = false;
        ProtectSystem = "strict";
        ProtectHome = true;
        RestrictNamespaces = false;
      };

      environment = {
        RUST_LOG = "info";
      };
    };

    systemd.services.sccache-scheduler = {
      description = "sccache-dist scheduler";
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        ExecStart = "${cfg.package}/bin/sccache-dist scheduler --config /etc/sccache/scheduler.conf";
        Restart = "on-failure";
        RestartSec = 5;

        CapabilityBoundingSet = "CAP_SYS_ADMIN CAP_SETUID CAP_SETGID CAP_DAC_OVERRIDE CAP_CHOWN";
        AmbientCapabilities = "CAP_SYS_ADMIN CAP_SETUID CAP_SETGID CAP_DAC_OVERRIDE CAP_CHOWN";

        # Allow access to necessary directories
        ReadWritePaths = [
          cfg.cacheDir
          cfg.buildDir
          "/var/lib/sccache"
        ];

        # Security settings (but allow namespaces for bwrap)
        NoNewPrivileges = false;
        ProtectSystem = "strict";
        ProtectHome = true;
        RestrictNamespaces = false;
      };

      environment = {
        RUST_LOG = "info";
      };
    };
  };
}
