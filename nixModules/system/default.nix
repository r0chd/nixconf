{ lib, config, ... }:
{
  imports = [
    ./bootloader
    ./virtualisation
    ./impermanence
    ./ydotool
    ./gc
    ./displayManager
  ];

  options.system.fileSystem = lib.mkOption {
    type = lib.types.enum [
      "btrfs"
      "ext4"
      "zfs"
    ];
  };

  config.services = {
    zfs.autoScrub.enable = lib.mkDefault (config.system.fileSystem == "zfs");
    zfs.autoSnapshot.enable = lib.mkDefault (config.system.fileSystem == "zfs");
  };
}
