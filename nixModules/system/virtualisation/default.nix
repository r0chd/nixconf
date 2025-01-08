{
  config,
  lib,
  systemUsers,
  ...
}:
let
  cfg = config.virtualisation;
in
{
  imports = [
    ./distrobox
    ./looking-glass
  ];

  options.virtualisation = {
    enable = lib.mkEnableOption "Virtualisation";
    virt-manager.enable = lib.mkEnableOption "Enable virt-manager";
  };

  config = lib.mkIf cfg.enable {
    virtualisation.libvirtd = {
      enable = true;
      onBoot = "ignore";
      onShutdown = "shutdown";
    };

    users.users =
      systemUsers
      |> lib.mapAttrs (
        user: value: {
          extraGroups = lib.mkIf value.root.enable [
            "libvirtd"
          ];
        }
      );

    programs.virt-manager.enable = cfg.virt-manager.enable;

    systemd.services.virtlockd = {
      serviceConfig = {
        ProtectSystem = "strict";
        ProtectHome = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;
        ProtectKernelLogs = true;
        ProtectClock = true;
        ProtectProc = "invisible";
        ProcSubset = "pid";
        PrivateTmp = true;
        PrivateUsers = true;
        PrivateDevices = true; # May need adjustment for accessing VM resources
        PrivateIPC = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        LockPersonality = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        RestrictAddressFamilies = "AF_INET AF_INET6";
        RestrictNamespaces = true;
        SystemCallFilter = [ "@system-service" ]; # Adjust as necessary
        SystemCallArchitectures = "native";
        UMask = "0077";
        IPAddressDeny = "any"; # May need adjustment for network operations
      };
    };
    #systemd.services.virtlogd = {
    #  serviceConfig = {
    #    ProtectSystem = "strict";
    #    ProtectHome = true;
    #    ProtectKernelTunables = true;
    #    ProtectKernelModules = true;
    #    ProtectControlGroups = true;
    #    ProtectKernelLogs = true;
    #    ProtectClock = true;
    #    ProtectProc = "invisible";
    #    ProcSubset = "pid";
    #    PrivateTmp = true;
    #    PrivateUsers = true;
    #    PrivateDevices = true; # May need adjustment for accessing VM logs
    #    PrivateIPC = true;
    #    MemoryDenyWriteExecute = true;
    #    NoNewPrivileges = true;
    #    LockPersonality = true;
    #    RestrictRealtime = true;
    #    RestrictSUIDSGID = true;
    #    RestrictAddressFamilies = "AF_INET AF_INET6";
    #    RestrictNamespaces = true;
    #    SystemCallFilter = [ "@system-service" ]; # Adjust based on log management needs
    #    SystemCallArchitectures = "native";
    #    UMask = "0077";
    #    IPAddressDeny = "any"; # May need to be relaxed for network-based log collection
    #  };
    #};
    systemd.services.virtlxcd = {
      serviceConfig = {
        ProtectSystem = "strict";
        ProtectHome = true;
        ProtectKernelTunables = true; # Necessary for container management
        ProtectKernelModules = true;
        ProtectControlGroups = true;
        ProtectKernelLogs = true;
        ProtectClock = true;
        ProtectProc = "invisible";
        ProcSubset = "pid";
        PrivateTmp = true;
        PrivateUsers = true; # Be cautious, might need adjustment for container user management
        PrivateDevices = true; # Containers might require broader device access
        PrivateIPC = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        LockPersonality = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        RestrictAddressFamilies = "AF_INET AF_INET6"; # Necessary for networked containers
        RestrictNamespaces = true;
        SystemCallFilter = [ "@system-service" ]; # Adjust based on container operations
        SystemCallArchitectures = "native";
        UMask = "0077";
        IPAddressDeny = "any"; # May need to be relaxed for network functionality
      };
    };
    systemd.services.virtqemud = {
      serviceConfig = {
        ProtectSystem = "strict";
        ProtectHome = true;
        ProtectKernelTunables = true; # Necessary for VM management
        ProtectKernelModules = true; # May need adjustment for VM hardware emulation
        ProtectControlGroups = true;
        ProtectKernelLogs = true;
        ProtectClock = true;
        ProtectProc = "invisible";
        ProcSubset = "pid";
        PrivateTmp = true;
        PrivateUsers = true; # Be cautious, might need adjustment for VM user management
        PrivateDevices = true; # VMs might require broader device access
        PrivateIPC = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        LockPersonality = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        RestrictAddressFamilies = "AF_INET AF_INET6"; # Necessary for networked VMs
        RestrictNamespaces = true;
        SystemCallFilter = [ "@system-service" ]; # Adjust based on VM operations
        SystemCallArchitectures = "native";
        UMask = "0077";
        IPAddressDeny = "any"; # May need to be relaxed for network functionality
      };
    };
    systemd.services.virtvboxd = {
      serviceConfig = {
        ProtectSystem = "strict";
        ProtectHome = true;
        ProtectKernelTunables = true; # Required for some VM management tasks
        ProtectKernelModules = true; # May need adjustment for module handling
        ProtectControlGroups = true;
        ProtectKernelLogs = true;
        ProtectClock = true;
        ProtectProc = "invisible";
        ProcSubset = "pid";
        PrivateTmp = true;
        PrivateUsers = true; # Be cautious, might need adjustment for VM user management
        PrivateDevices = true; # VMs may require access to certain devices
        PrivateIPC = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        LockPersonality = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        RestrictAddressFamilies = "AF_INET AF_INET6"; # Necessary for networked VMs
        RestrictNamespaces = true;
        SystemCallFilter = [ "@system-service" ]; # Adjust based on VM operations
        SystemCallArchitectures = "native";
        UMask = "0077";
        IPAddressDeny = "any"; # May need to be relaxed for network functionality
      };
    };
  };
}
