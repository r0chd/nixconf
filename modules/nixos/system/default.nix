{ lib, ... }:
{
  imports = [
    ./bootloader
    ./impermanence
    ./ydotool
    ./displayManager
  ];

  options.system.fileSystem = lib.mkOption {
    type = lib.types.enum [
      "btrfs"
      "ext4"
      "zfs"
    ];
  };

  config.system.stateVersion = "25.11";
}
