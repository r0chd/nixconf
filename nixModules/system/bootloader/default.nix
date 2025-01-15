{ lib, config, ... }:
let
  cfg = config.system.bootloader;
in
{
  options.system.bootloader = {
    silent = lib.mkEnableOption "Enable silent boot";
    variant = lib.mkOption {
      type = lib.types.enum [
        "grub"
        "systemd-boot"
        "lanzaboote"
      ];
    };
  };

  imports = [
    ./systemd-boot
    ./grub
    ./lanzaboote
  ];

  config = {
    boot = {
      plymouth.enable = true;
      loader.systemd-boot.enable = lib.mkDefault false;
      supportedFilesystems = [ config.system.fileSystem ];
      kernelModules = [ "v4l2loopback" ];

      consoleLogLevel = lib.mkIf cfg.silent 0;
      initrd.verbose = lib.mkIf cfg.silent false;
      kernelParams =
        [
          "slab_nomerge"
          "init_on_alloc=1"
          "init_on_free=1"
          "page_alloc.shuffle=1"
          "pti=on"
          "vsyscall=none"
          "debugfs=off"
          "oops=panic"
          "module.sig_enforce=1"
          "lockdown=off"
          "mce=0"
          "spectre_v2=on"
          "spec_store_bypass_disable=on"
        ]
        ++ (
          if cfg.silent then
            [
              "quiet"
              "splash"
              "boot.shell_on_fail"
              "loglevel=3"
              "rd.systemd.show_status=false"
              "rd.udev.log_level=3"
              "udev.log_priority=3"
            ]
          else
            [ ]
        );

      blacklistedKernelModules = [
        "dccp"
        "sctp"
        "rds"
        "tipc"
        "n-hdlc"
        "ax25"
        "netrom"
        "x25"
        "rose"
        "decnet"
        "econet"
        "af_802154"
        "ipx"
        "appletalk"
        "psnap"
        "p8023"
        "p8022"
        "can"
        "atm"
        "cramfs"
        "freevxfs"
        "jffs2"
        "hfs"
        "hfsplus"
        "udf"
        "vivid"
        "thunderbolt"
        "firewire-core"
      ];

      loader = {
        timeout = 255;
        efi = {
          canTouchEfiVariables = true;
          efiSysMountPoint = "/boot";
        };
      };
    };

    fileSystems."/proc" = {
      fsType = "proc";
      device = "proc";
      options = [
        "nosuid"
        "nodev"
        "noexec"
        "hidepid=2"
      ];
      neededForBoot = true;
    };

    users.groups.proc = { };

    #boot.initrd.systemd.enable = true;
    systemd = {
      services.systemd-logind.serviceConfig.SupplementaryGroups = [ "proc" ];
      coredump.enable = false;
    };
    services = {
      journald.forwardToSyslog = true;
      syslogd = {
        enable = true;
        extraConfig = ''
          *.*  -/var/log/syslog
        '';
      };
    };
  };
}
