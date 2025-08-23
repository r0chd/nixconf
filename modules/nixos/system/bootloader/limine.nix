{ config, lib, ... }:
let
  cfg = config.system.bootloader;
in
{
  boot.loader.limine = lib.mkIf (cfg.variant == "limine") {
    enable = true;
    enableEditor = true;
    biosSupport = cfg.legacy;
    biosDevice = lib.mkIf (!cfg.legacy) "nodev";
  };
}
