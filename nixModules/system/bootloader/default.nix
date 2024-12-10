{ lib, config, ... }:
{
  options.system.bootloader = lib.mkOption {
    type = lib.types.enum [
      "grub"
      "systemd-boot"
      "lanzaboote"
    ];
  };

  imports = [
    ./systemd-boot
    ./grub
    ./lanzaboote
  ];

  config.boot = {
    loader.systemd-boot.enable = lib.mkDefault false;
    supportedFilesystems = [ config.system.fileSystem ];
    kernelModules = [ "v4l2loopback" ];
    kernelParams = [ "nvidia.NVreg_PreserveVideoMemoryAllocations=1" ];
    loader = {
      timeout = 255;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
    };
  };
}
