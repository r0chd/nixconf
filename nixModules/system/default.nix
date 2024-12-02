{ lib, ... }:
{
  imports = [
    ./bootloader
    ./virtualization
    ./impermanence
    ./ydotool
    ./gc
  ];

  options.system.fileSystem = lib.mkOption {
    type = lib.types.enum [ "btrfs" ];
  };
}
