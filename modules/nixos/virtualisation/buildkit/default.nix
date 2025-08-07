{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.virtualisation.buildkitd;
  inherit (lib) types;
in
{
  options.virtualisation.buildkitd = {
    enable = lib.mkEnableOption "buildkit";
    rootless = lib.mkEnableOption "rootless-buildkit";
    listenOptions = lib.mkOption {
      type = types.listOf types.str;
      default = [ "/run/buildkit/buildkitd.sock" ];
      description = ''
        A list of unix and tcp buildkitd should listen to. The format follows
        ListenStream as described in systemd.socket(5).
      '';
    };
    package = lib.mkOption {
      default = pkgs.buildkit;
      type = types.package;
      example = pkgs.buildkit;
      description = ''
        Buildkitd package to be used in the module
      '';
    };
    packages = lib.mkOption {
      type = types.listOf types.package;
      default = [
        pkgs.runc
        pkgs.git
      ];
      description = "List of packages to be added to buildkitd service path";
    };
    extraOptions = lib.mkOption {
      type = types.separatedString " ";
      default = "";
      description = ''
        The extra command-line options to pass to
        <command>buildkitd</command> daemon.
      '';
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      environment.systemPackages = [ cfg.package ];

      systemd.sockets.buildkitd = {
        description = "Buildkitd Socket for the API";
        wantedBy = [ "sockets.target" ];
        socketConfig = {
          ListenStream = cfg.listenOptions;
          SocketMode = "0660";
          SocketUser = "buildkit";
          SocketGroup = "buildkit";
        };
      };
    })

    (lib.mkIf (cfg.enable && !cfg.rootless) {
      users.groups.buildkit.gid = 350;
      systemd = {
        packages = [ cfg.package ];
        services.buildkitd = {
          wants = [ "containerd.service" ];
          after = [ "containerd.service" ];
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            ExecStart = [
              ""
              ''
                ${cfg.package}/bin/buildkitd \
                  ${cfg.extraOptions}
              ''
            ];
          };
          path = [ cfg.package ] ++ cfg.packages;
        };
      };
    })

    (lib.mkIf (cfg.enable && cfg.rootless) {
      users = {
        users.buildkit = {
          description = "buildkit user";
          isSystemUser = true;
          useDefaultShell = true;
        };
        groups.buildkit = { };
      };

      security.wrappers = {
        newuidmap = {
          source = "${pkgs.shadow}/bin/newuidmap";
          setuid = true;
        };
        newgidmap = {
          source = "${pkgs.shadow}/bin/newgidmap";
          setuid = true;
        };
      };

      systemd.services.buildkitd = {
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        wants = [ "network.target" ];
        path = [
          (builtins.dirOf config.security.wrapperDir)
          pkgs.runc
        ];

        serviceConfig = {
          Type = "simple";
          User = config.users.users.buildkit.name;
          StateDirectory = "buildkit";
          RuntimeDirectory = "buildkit";
          ExecStart = "${pkgs.rootlesskit}/bin/rootlesskit ${pkgs.buildkit}/bin/buildkitd --rootless --addr unix:///run/buildkit/buildkitd.sock";
          Restart = "on-failure";
          RestartSec = "5s";
        };
      };
    })
  ];
}
