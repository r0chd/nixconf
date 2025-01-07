# Systemd hardening
{ ... }:
{
  systemd.services.systemd-rfkill = {
    serviceConfig = {
      ProtectSystem = "strict";
      ProtectHome = true;
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectControlGroups = true;
      ProtectClock = true;
      ProtectProc = "invisible";
      ProcSubset = "pid";
      PrivateTmp = true;
      MemoryDenyWriteExecute = true;
      NoNewPrivileges = true;
      LockPersonality = true;
      RestrictRealtime = true;
      SystemCallFilter = [
        "write"
        "read"
        "openat"
        "close"
        "brk"
        "fstat"
        "lseek"
        "mmap"
        "mprotect"
        "munmap"
        "rt_sigaction"
        "rt_sigprocmask"
        "ioctl"
        "nanosleep"
        "select"
        "access"
        "execve"
        "getuid"
        "arch_prctl"
        "set_tid_address"
        "set_robust_list"
        "prlimit64"
        "pread64"
        "getrandom"
      ];
      SystemCallArchitectures = "native";
      UMask = "0077";
      IPAddressDeny = "any";
    };
  };
  systemd.services.syslog = {
    serviceConfig = {
      PrivateNetwork = true;
      CapabilityBoundingSet = [
        "CAP_DAC_READ_SEARCH"
        "CAP_SYSLOG"
        "CAP_NET_BIND_SERVICE"
      ];
      NoNewPrivileges = true;
      PrivateDevices = true;
      ProtectClock = true;
      ProtectKernelLogs = true;
      ProtectKernelModules = true;
      PrivateMounts = true;
      SystemCallArchitectures = "native";
      MemoryDenyWriteExecute = true;
      LockPersonality = true;
      ProtectKernelTunables = true;
      RestrictRealtime = true;
      PrivateUsers = true;
      PrivateTmp = true;
      UMask = "0077";
      RestrictNamespace = true;
      ProtectProc = "invisible";
      ProtectHome = true;
      DeviceAllow = false;
      ProtectSystem = "full";
    };
  };

  systemd.services.systemd-journald = {
    serviceConfig = {
      UMask = 77;
      PrivateNetwork = true;
      ProtectHostname = true;
      ProtectKernelModules = true;
    };
  };
  systemd.services.emergency = {
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
      PrivateDevices = true; # Might need adjustment for emergency access
      PrivateIPC = true;
      MemoryDenyWriteExecute = true;
      NoNewPrivileges = true;
      LockPersonality = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      RestrictAddressFamilies = "AF_INET";
      RestrictNamespaces = true;
      SystemCallFilter = [
        "write"
        "read"
        "openat"
        "close"
        "brk"
        "fstat"
        "lseek"
        "mmap"
        "mprotect"
        "munmap"
        "rt_sigaction"
        "rt_sigprocmask"
        "ioctl"
        "nanosleep"
        "select"
        "access"
        "execve"
        "getuid"
        "arch_prctl"
        "set_tid_address"
        "set_robust_list"
        "prlimit64"
        "pread64"
        "getrandom"
      ];
      UMask = "0077";
      IPAddressDeny = "any";
    };
  };
  systemd.services."getty@tty1" = {
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
      PrivateDevices = true;
      PrivateIPC = true;
      MemoryDenyWriteExecute = true;
      NoNewPrivileges = true;
      LockPersonality = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      RestrictAddressFamilies = "AF_INET";
      RestrictNamespaces = true;
      SystemCallFilter = [
        "write"
        "read"
        "openat"
        "close"
        "brk"
        "fstat"
        "lseek"
        "mmap"
        "mprotect"
        "munmap"
        "rt_sigaction"
        "rt_sigprocmask"
        "ioctl"
        "nanosleep"
        "select"
        "access"
        "execve"
        "getuid"
        "arch_prctl"
        "set_tid_address"
        "set_robust_list"
        "prlimit64"
        "pread64"
        "getrandom"
      ];
      SystemCallArchitectures = "native";
      UMask = "0077";
      IPAddressDeny = "any";
    };
  };
  systemd.services."getty@tty7" = {
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
      PrivateDevices = true;
      PrivateIPC = true;
      MemoryDenyWriteExecute = true;
      NoNewPrivileges = true;
      LockPersonality = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      RestrictAddressFamilies = "AF_INET";
      RestrictNamespaces = true;
      SystemCallFilter = [
        "write"
        "read"
        "openat"
        "close"
        "brk"
        "fstat"
        "lseek"
        "mmap"
        "mprotect"
        "munmap"
        "rt_sigaction"
        "rt_sigprocmask"
        "ioctl"
        "nanosleep"
        "select"
        "access"
        "execve"
        "getuid"
        "arch_prctl"
        "set_tid_address"
        "set_robust_list"
        "prlimit64"
        "pread64"
        "getrandom"
      ];
      SystemCallArchitectures = "native";
      UMask = "0077";
      IPAddressDeny = "any";
    };
  };
  systemd.services."nixos-rebuild-switch-to-configuration" = {
    serviceConfig = {
      ProtectHome = true;
      NoNewPrivileges = true; # Prevent gaining new privileges
    };
  };
  systemd.services."dbus" = {
    serviceConfig = {
      PrivateTmp = true;
      PrivateNetwork = true;
      ProtectSystem = "full";
      ProtectHome = true;
      SystemCallFilter = "~@clock @cpu-emulation @module @mount @obsolete @raw-io @reboot @swap";
      ProtectKernelTunables = true;
      NoNewPrivileges = true;
      CapabilityBoundingSet = [
        "~CAP_SYS_TIME"
        "~CAP_SYS_PACCT"
        "~CAP_KILL"
        "~CAP_WAKE_ALARM"
        "~CAP_SYS_BOOT"
        "~CAP_SYS_CHROOT"
        "~CAP_LEASE"
        "~CAP_MKNOD"
        "~CAP_NET_ADMIN"
        "~CAP_SYS_ADMIN"
        "~CAP_SYSLOG"
        "~CAP_NET_BIND_SERVICE"
        "~CAP_NET_BROADCAST"
        "~CAP_AUDIT_WRITE"
        "~CAP_AUDIT_CONTROL"
        "~CAP_SYS_RAWIO"
        "~CAP_SYS_NICE"
        "~CAP_SYS_RESOURCE"
        "~CAP_SYS_TTY_CONFIG"
        "~CAP_SYS_MODULE"
        "~CAP_IPC_LOCK"
        "~CAP_LINUX_IMMUTABLE"
        "~CAP_BLOCK_SUSPEND"
        "~CAP_MAC_*"
        "~CAP_DAC_*"
        "~CAP_FOWNER"
        "~CAP_IPC_OWNER"
        "~CAP_SYS_PTRACE"
        "~CAP_SETUID"
        "~CAP_SETGID"
        "~CAP_SETPCAP"
        "~CAP_FSETID"
        "~CAP_SETFCAP"
        "~CAP_CHOWN"
      ];
      ProtectKernelModules = true;
      ProtectKernelLogs = true;
      ProtectClock = true;
      ProtectControlGroups = true;
      RestrictNamespaces = true;
      MemoryDenyWriteExecute = true;
      RestrictAddressFamilies = [
        "~AF_PACKET"
        "~AF_NETLINK"
      ];
      ProtectHostname = true;
      LockPersonality = true;
      RestrictRealtime = true;
      PrivateUsers = true;
    };
  };
  systemd.services.nix-daemon = {
    serviceConfig = {
      ProtectHome = true;
      PrivateUsers = false;
    };
  };
  systemd.services.reload-systemd-vconsole-setup = {
    serviceConfig = {
      ProtectSystem = "strict";
      ProtectHome = true;
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectControlGroups = true;
      ProtectKernelLogs = true;
      ProtectClock = true;
      PrivateUsers = true;
      PrivateDevices = true;
      MemoryDenyWriteExecute = true;
      NoNewPrivileges = true;
      LockPersonality = true;
      RestrictRealtime = true;
      RestrictNamespaces = true;
      UMask = "0077";
      IPAddressDeny = "any";
    };
  };
  systemd.services.rescue = {
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
      PrivateDevices = true; # Might need adjustment for rescue operations
      PrivateIPC = true;
      MemoryDenyWriteExecute = true;
      NoNewPrivileges = true;
      LockPersonality = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      RestrictAddressFamilies = "AF_INET AF_INET6"; # Networking might be necessary in rescue mode
      RestrictNamespaces = true;
      SystemCallFilter = [
        "write"
        "read"
        "openat"
        "close"
        "brk"
        "fstat"
        "lseek"
        "mmap"
        "mprotect"
        "munmap"
        "rt_sigaction"
        "rt_sigprocmask"
        "ioctl"
        "nanosleep"
        "select"
        "access"
        "execve"
        "getuid"
        "arch_prctl"
        "set_tid_address"
        "set_robust_list"
        "prlimit64"
        "pread64"
        "getrandom"
      ];
      SystemCallArchitectures = "native";
      UMask = "0077";
      IPAddressDeny = "any"; # May need to be relaxed for network troubleshooting in rescue mode
    };
  };
  systemd.services."systemd-ask-password-console" = {
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
      PrivateDevices = true; # May need adjustment for console access
      PrivateIPC = true;
      MemoryDenyWriteExecute = true;
      NoNewPrivileges = true;
      LockPersonality = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      RestrictAddressFamilies = "AF_INET AF_INET6";
      RestrictNamespaces = true;
      SystemCallFilter = [ "@system-service" ]; # A more permissive filter
      SystemCallArchitectures = "native";
      UMask = "0077";
      IPAddressDeny = "any";
    };
  };
  systemd.services."systemd-ask-password-wall" = {
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
      PrivateDevices = true;
      PrivateIPC = true;
      MemoryDenyWriteExecute = true;
      NoNewPrivileges = true;
      LockPersonality = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      RestrictAddressFamilies = "AF_INET AF_INET6";
      RestrictNamespaces = true;
      SystemCallFilter = [ "@system-service" ]; # A more permissive filter
      SystemCallArchitectures = "native";
      UMask = "0077";
      IPAddressDeny = "any";
    };
  };
}
