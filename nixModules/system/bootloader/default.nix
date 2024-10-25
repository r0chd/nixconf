{ conf }: {
  imports = [
    (if conf.boot.loader == "systemd-boot" then
      (import ./systemd-boot)
    else if conf.boot.loader == "grub" then
      (import ./grub)
    else
      [ ])
  ];

  boot = {
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
