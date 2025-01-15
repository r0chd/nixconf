{ lib, ... }:
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
    type = lib.types.enum [ "btrfs" ];
  };
}
