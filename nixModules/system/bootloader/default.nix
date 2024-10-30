{ lib, ... }: {
  options.boot = {
    program = lib.mkOption { type = lib.types.enum [ "grub" "systemd-boot" ]; };
    legacy = lib.mkEnableOption "Enable legacy boot";
  };

  imports = [ ./systemd-boot ./grub ];

  # TODO: do the legacy boot thing
  config.boot = {
    loader.systemd-boot.enable = lib.mkDefault false;
    supportedFilesystems = [ "btrfs" ];
    kernelModules = [ "v4l2loopback" ];
    kernelParams = [ "nvidia.NVreg_PreserveVideoMemoryAllocations=1" ];
    loader = {
      timeout = null;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
    };
  };
}
