{ config, lib, ... }:
{
  config = lib.mkIf (config.boot.program == "grub") {
    boot.loader.grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      useOSProber = true;
    };
  };
}
