{ lib, ... }:
{
  imports = [
    ./bootloader
    ./virtualisation
    ./impermanence
    ./ydotool
    ./gc
    ./displayManager
    ./raspberry-pi
  ];

  options.system.fileSystem = lib.mkOption {
    type = lib.types.enum [
      "btrfs"
      "ext4"
    ];
  };
}
