{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.tailscale;
in
{
  options.services.tailscale = {
    funnel = {
      enable = lib.mkEnableOption "tailscale funnel";
      port = lib.mkOption {
        type = lib.types.ints.between 1 65535;
        default = 80;
        description = "Port to expose via Tailscale funnel";
      };
    };
  };

  config = {
    systemd.services.tailscale-funnel = {
      inherit (cfg.funnel) enable;
      description = "Tailscale funnel";
      wantedBy = [ "multi-user.target" ];
      after = [
        "tailscaled.service"
        "network-online.target"
      ];
      wants = [ "network-online.target" ];
      requires = [ "tailscaled.service" ];
      serviceConfig = {
        Type = "simple";
        Restart = "on-failure";
        RestartSec = "5s";
      };
      script = ''
        ${pkgs.tailscale}/bin/tailscale funnel ${builtins.toString cfg.funnel.port}
      '';
    };

    environment = {
      systemPackages = [ pkgs.tailscale ];
      persist.directories = [ "/var/lib/tailscale" ];
    };

    services.tailscale.enable = true;

    boot.initrd = {
      systemd = {
        packages = [ cfg.package ];
        initrdBin = [
          pkgs.iptables
          pkgs.iproute2
          cfg.package
        ];
        services = {
          tailscaled = {
            wantedBy = [ "initrd.target" ];
            serviceConfig.Environment = [
              "PORT=${toString cfg.port}"
              ''"FLAGS=--tun ${lib.escapeShellArg cfg.interfaceName}"''
            ];
          };
          systemd-resolved = {
            wantedBy = [ "initrd.target" ];
            serviceConfig.ExecStartPre = "-+/bin/ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf";
          };
        };

        contents = {
          "/etc/tmpfiles.d/50-tailscale.conf".text = ''
            L /var/run - - - - /run
          '';
          "/etc/hostname".source = lib.mkForce config.environment.etc.hostname.source;
        };
        network.networks."50-tailscale" = {
          matchConfig = {
            Name = cfg.interfaceName;
          };
          linkConfig = {
            Unmanaged = true;
            ActivationPolicy = "manual";
          };
        };

        extraBin.ping = "${pkgs.iputils}/bin/ping";

        additionalUpstreamUnits = [ "systemd-resolved.service" ];
        users.systemd-resolve = { };
        groups.systemd-resolve = { };
        storePaths = [ "${config.boot.initrd.systemd.package}/lib/systemd/systemd-resolved" ];
      };

      availableKernelModules = [
        "tun"
        "nft_chain_nat"
      ];
    };
  };
}
