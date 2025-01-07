{
  config,
  pkgs,
  lib,
  hostname,
  ...
}:
let
  cfg = config.network.wireless;
in
{
  options.network.wireless.enable = lib.mkEnableOption "Enable wireless wifi connection";

  config = lib.mkIf cfg.enable {
    networking = {
      firewall.enable = true;

      wireless.iwd = {
        enable = true;
      };
      hostName = "${hostname}";
      nameservers = [
        "1.1.1.1"
        "1.0.0.1"
      ];
    };

    environment.systemPackages = with pkgs; [
      wirelesstools
      traceroute
      inetutils
    ];

    system.impermanence.persist.directories = [ "/var/lib/iwd" ];

    systemd.services.iwd = {
      serviceConfig = {
        NoNewPrivileges = true;
        ProtectClock = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
        ProtectKernelModules = true;
        SystemCallArchitectures = "native";
        MemoryDenyWriteExecute = true;
        ProtectProc = "invisible";
        ProcSubset = "pid";
        RestrictNamespaces = true;
        ProtectKernelTunables = true;
        ProtectHome = true;
        PrivateTmp = true;
        UMask = "0077";
      };
    };
  };
}
