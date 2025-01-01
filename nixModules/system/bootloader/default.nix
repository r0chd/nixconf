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

  config.boot = {
    plymouth.enable = true;
    loader.systemd-boot.enable = lib.mkDefault false;
    supportedFilesystems = [ config.system.fileSystem ];
    kernelModules = [ "v4l2loopback" ];

    consoleLogLevel = lib.mkIf cfg.silent 0;
    initrd.verbose = lib.mkIf cfg.silent false;
    kernelParams =
      [
        "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
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

    loader = {
      timeout = 255;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
    };
  };
}
