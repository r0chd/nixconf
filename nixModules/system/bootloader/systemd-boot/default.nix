{ config, lib, ... }:
let
  cfg = config.system.bootloader;
in
{
  config = lib.mkIf (cfg == "systemd-boot") {
    boot.loader.systemd-boot.enable = true;
  };
}
