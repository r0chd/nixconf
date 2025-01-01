{ config, lib, ... }:
let
  cfg = config.system.bootloader;
in
{
  boot.loader.systemd-boot = lib.mkIf (cfg.variant == "systemd-boot") {
    enable = true;
    editor = true;
  };
}
