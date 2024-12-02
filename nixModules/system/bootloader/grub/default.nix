{ config, lib, ... }:
let
  cfg = config.system.bootloader;
in
{
  config = lib.mkIf (cfg == "grub") {
    boot.loader.grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      useOSProber = true;
    };
  };
}
