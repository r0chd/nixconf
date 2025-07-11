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

  config.system = {
    includeBuildDependencies = true;
    stateVersion = "25.11";
  };
}
