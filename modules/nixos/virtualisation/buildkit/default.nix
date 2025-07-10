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
      default = [ "/run/buildkitd/buildkitd.sock" ];
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
    (lib.mkIf cfg.enable { environment.systemPackages = [ cfg.package ]; })

    (lib.mkIf (cfg.enable && !cfg.rootless) {
      users.groups = [
        {
          name = "buildkit";
          gid = 350;
        }
      ];
      systemd.packages = [ cfg.package ];
      systemd.services.buildkitd = {
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
      systemd.sockets.buildkitd = {
        description = "Buildkitd Socket for the API";
        wantedBy = [ "sockets.target" ];
        socketConfig = {
          ListenStream = cfg.listenOptions;
          SocketMode = "0660";
          SocketUser = "root";
          SocketGroup = "buildkit";
        };
      };
    })

    (lib.mkIf (cfg.enable && cfg.rootless) {
      users = {
        users.buildkit = {
          description = "buildkit user";
          isNormalUser = true;
          useDefaultShell = true;
        };
        groups.buildkit = { };
      };

      systemd.services.buildkitd = {
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        wants = [ "network.target" ];

        serviceConfig = {
          Type = "simple";
          User = config.users.users.buildkit.name;
          StateDirectory = "buildkit";
          RuntimeDirectory = "buildkit";
          ExecStart = "${pkgs.rootlesskit}/bin/rootlesskit ${pkgs.buildkit}/bin/buildkitd --rootless --addr unix:///run/buildkit/buildkitd.sock";
          Restart = "on-failure";
          RestartSec = "5s";
        };
        path = builtins.attrValues { inherit (pkgs) shadow runc; };
      };
    })
  ];
}
