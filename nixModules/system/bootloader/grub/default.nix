{ config, lib, ... }:
let
  cfg = config.system.bootloader;
in
{
  boot.loader.grub = lib.mkIf (cfg.variant == "grub") {
    enable = true;
    device = "nodev";
    efiSupport = true;
    useOSProber = true;
  };
}
