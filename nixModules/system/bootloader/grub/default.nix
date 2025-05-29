{ config, lib, ... }:
let
  cfg = config.system.bootloader;
in
{
  boot.loader.grub = lib.mkIf (cfg.variant == "grub") {
    enable = true;
    device = lib.mkIf (!cfg.legacy) "nodev";
    efiSupport = !cfg.legacy;
    useOSProber = true;
  };
}
