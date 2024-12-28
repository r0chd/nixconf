{ lib, ... }:
{
  imports = [
    ./bootloader
    ./virtualisation
    ./impermanence
    ./ydotool
    ./gc
  ];

  options.system.fileSystem = lib.mkOption {
    type = lib.types.enum [ "btrfs" ];
  };
}
