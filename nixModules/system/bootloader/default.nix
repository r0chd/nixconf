{ conf, lib }: {
  options.boot = {
    program = lib.mkOption { type = lib.types.enum [ "grub" "systemd-boot" ]; };
    legacy = lib.mkEnableOption "Enable legacy boot";
  };

  imports = [
    (import ./systemd-boot { inherit conf lib; })
    (import ./grub { inherit conf lib; })
  ];

  # TODO: do the legacy boot thing
  config.boot = {
    program.systemd-boot.enable = lib.mkDefault false;
    supportedFilesystems = [ "ntfs" "btrfs" ];
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
