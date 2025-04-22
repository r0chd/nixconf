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
  config = {
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
